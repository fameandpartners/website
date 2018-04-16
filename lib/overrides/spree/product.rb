require 'elasticsearch/model'

module Overrides
  module Spree
    module Product
      extend ActiveSupport::Concern

      included do
        include Tire::Model::Search
        include Tire::Model::Callbacks
        # include Elastic::Model


        has_one :style_profile,
                :class_name => '::ProductStyleProfile',
                :foreign_key => :product_id

        mapping do
          indexes :id, :index => :not_analyzed

          indexes :created_at, :type => :date

          indexes :name, :analyzer => :snowball
          indexes :description, :analyzer => :snowball
          indexes :price, :type => :float, :as => 'price_for_search'

          indexes :discount, :type => :integer, as: 'discount.try(:amount).to_i'
          indexes :on_sale,  :type => :boolean, as: 'discount.try(:amount).to_i > 0'

          indexes :available_on, :type => :date, :include_in_all => false
          indexes :deleted, :index => :not_analyzed, :as => 'deleted_at.present?'
          indexes :in_stock, :type => :boolean, :as => 'has_stock?'
          indexes :position, :type => :integer, :index => :not_analyzed
          indexes :fast_delivery, :type => :boolean, :as => 'fast_delivery'
          indexes :fast_making, :type => :boolean, :as => 'fast_making'
          indexes :super_fast_making, :type => :boolean, :as => 'super_fast_making'

          indexes :taxons, :as => 'taxons.map(&:name)'
          indexes :taxon_ids, :as => 'taxons.map(&:id)'

          indexes :featured, :type => :boolean, :as => 'featured'
          indexes :hidden,   :type => :boolean, :as => 'hidden'

          indexes :colors, :as => 'colors'
          indexes :color_ids, :as => 'color_ids'

          indexes :viewable_color_ids, :as => 'viewable_color_ids'

          indexes :glam, :type => :float, :as => 'style_profile.try(:glam)'
          indexes :girly, :type => :float, :as => 'style_profile.try(:girly)'
          indexes :classic, :type => :float, :as => 'style_profile.try(:classic)'
          indexes :edgy, :type => :float, :as => 'style_profile.try(:edgy)'
          indexes :bohemian, :type => :float, :as => 'style_profile.try(:bohemian)'

          indexes :sexiness, :type => :float, :as => 'style_profile.try(:sexiness)'
          indexes :fashionability, :type => :float, :as => 'style_profile.try(:fashionability)'

          indexes :apple, :type => :float, :as => 'style_profile.try(:apple)'
          indexes :pear, :type => :float, :as => 'style_profile.try(:pear)'
          indexes :athletic, :type => :float, :as => 'style_profile.try(:athletic)'
          indexes :strawberry, :type => :float, :as => 'style_profile.try(:strawberry)'
          indexes :hour_glass, :type => :float, :as => 'style_profile.try(:hour_glass)'
          indexes :column, :type => :float, :as => 'style_profile.try(:column)'
          indexes :petite, :type => :float, :as => 'style_profile.try(:petite)'

          indexes :bra_aaa, :type => :float, :as => 'style_profile.try(:bra_aaa)'
          indexes :bra_aa, :type => :float, :as => 'style_profile.try(:bra_aa)'
          indexes :bra_a, :type => :float, :as => 'style_profile.try(:bra_a)'
          indexes :bra_b, :type => :float, :as => 'style_profile.try(:bra_b)'
          indexes :bra_c, :type => :float, :as => 'style_profile.try(:bra_c)'
          indexes :bra_d, :type => :float, :as => 'style_profile.try(:bra_d)'
          indexes :bra_e, :type => :float, :as => 'style_profile.try(:bra_e)'
          indexes :bra_fpp, :type => :float, :as => 'style_profile.try(:bra_fpp)'
        end

        before_create do
          build_style_profile
        end
      end

      BASIC_SORT_SCRIPT_INNER_PART =
        %q{
          (
            (doc['glam'].value - %{glam}) ** 2
          ) + (
            (doc['girly'].value - %{girly}) ** 2
          ) + (
            (doc['classic'].value - %{classic}) ** 2
          ) + (
            (doc['edgy'].value - %{edgy}) ** 2
          ) + (
            (doc['bohemian'].value - %{bohemian}) ** 2
          ) + (
            (doc['sexiness'].value - %{sexiness}) ** 2
          ) + (
            (doc['fashionability'].value - %{fashionability}) ** 2
          )
        }.gsub(/[\r\n]|([\s]{2,})/, '')

      module ClassMethods
        def sort_script_for(style_profile)
          additional_params = []
          additional_params << style_profile.body_shape
          additional_params << style_profile.brassiere_size

          additional_inner_part = ''

          additional_params.compact.each do |param|
            additional_inner_part += " + ((doc['#{param}'].value - %{#{param}}) ** 2)"
          end

          %Q{
            sqrt(#{BASIC_SORT_SCRIPT_INNER_PART}#{additional_inner_part})
          }.gsub(/[\r\n]|([\s]{2,})/, '')
        end

        def recommended_for(target, options = {})
          limit = options[:limit] || 12

          if target.is_a?(UserStyleProfile)
            style_profile = target
          else
            user = target
            style_profile = UserStyleProfile.find_by_user_id(user.id)
          end

          if style_profile.user_style_profile_taxons.present?
            recommended_for_style_profile(style_profile, (limit * 0.7).round) +
              recommended_by_taxon_ids(style_profile.user_style_profile_taxons.map(&:taxon_id), (limit * 0.3).round)
          else
            recommended_for_style_profile(style_profile, limit)
          end
        end

        def recommended_by_taxon_ids(taxon_ids, limit = 4)
          query = Tire.search(configatron.elasticsearch.indices.spree_products, :page => 1, :load => { :include => :master }) do
            filter :bool, :must => { :term => { :deleted => false } }
            filter :bool, :must => { :term => { :hidden => false } }
            filter :bool, :must => { :term => { :on_sale => false } }

            filter :exists, :field => :available_on

            filter :bool, :should => {
              :range => {
                :available_on => { :lte => Time.now }
              }
            }

            sort do
              by ({
                :_script => {
                  script: %q{
                    intersection_size = 0;

                    if ( doc.containsKey('taxon_ids') ) {
                      foreach( target_id : taxon_ids ) {
                        foreach( taxon_id : doc['taxon_ids'].values ) {
                          if ( target_id == taxon_id ) {
                            intersection_size += 1;
                          }
                        }
                      }

                      ratio = intersection_size / taxon_ids.size();
                      factor = 1;

                      if ( intersection_size == taxon_ids.size() ) {
                        if ( intersection_size == doc['taxon_ids'].values.size() ) {
                          factor = 2;
                        } else {
                          factor = 1.75;
                        }
                      } else {
                        if ( intersection_size == doc['taxon_ids'].values.size() ) {
                          factor = 1.5;
                        }
                      }

                      return (ratio * factor);
                    }

                    return 0;
                  }.gsub(/[\r\n]|([\s]{2,})/, ''),
                  params: {
                    taxon_ids: taxon_ids
                  },
                  type:   'number',
                  order:  'desc'
                }
              })
            end

            from 0
            size limit
          end

          begin
            query.results.results
          rescue ActiveRecord::RecordNotFound
            Tire.index(configatron.elasticsearch.indices.spree_products) do
              delete
              import ::Spree::Product.all
            end

            Tire.index(configatron.elasticsearch.indices.spree_products).refresh

            recommended_by_taxon_ids(taxon_ids, limit)
          end
        end

        def recommended_for_style_profile(style_profile, limit = 8)
          query = Tire.search(configatron.elasticsearch.indices.spree_products, :page => 1, :load => { :include => :master }) do
            filter :bool, :must => { :term => { :deleted => false } }
            filter :bool, :must => { :term => { :hidden => false } }
            filter :bool, :must => { :term => { :on_sale => false } }

            filter :exists, :field => :available_on

            filter :bool, :should => {
              :range => {
                :available_on => { :lte => Time.now }
              }
            }

            filter :or,
                   {
                     :bool => {:must_not => {:term => {:classic => 0}}}
                   }, {
                     :bool => {:must_not => {:term => {:glam => 0}}}
                   }, {
                     :bool => {:must_not => {:term => {:girly => 0}}}
                   }, {
                     :bool => {:must_not => {:term => {:edgy => 0}}}
                   }, {
                     :bool => {:must_not => {:term => {:bohemian => 0}}}
                   }

            sort do
              by ({
                :_script => {
                  :script => ::Spree::Product.sort_script_for(style_profile) % {
                    :glam => style_profile.glam,
                    :girly => style_profile.girly,
                    :classic => style_profile.classic,
                    :edgy => style_profile.edgy,
                    :bohemian => style_profile.bohemian,

                    :sexiness => style_profile.sexiness,
                    :fashionability => style_profile.fashionability,

                    :apple => style_profile.apple,
                    :pear => style_profile.pear,
                    :athletic => style_profile.athletic,
                    :strawberry => style_profile.strawberry,
                    :hour_glass => style_profile.hour_glass,
                    :column => style_profile.column,
                    :petite => style_profile.petite,

                    :bra_aaa => style_profile.bra_aaa,
                    :bra_aa => style_profile.bra_aa,
                    :bra_a => style_profile.bra_a,
                    :bra_b => style_profile.bra_b,
                    :bra_c => style_profile.bra_c,
                    :bra_d => style_profile.bra_d,
                    :bra_e => style_profile.bra_e,
                    :bra_fpp => style_profile.bra_fpp
                  },
                  type:   'number',
                  order:  'asc'
                }
              })
            end

            from 0
            size limit
          end

          begin
            query.results.results
          rescue ActiveRecord::RecordNotFound
            Tire.index(configatron.elasticsearch.indices.spree_products) do
              delete
              import ::Spree::Product.all
            end

            Tire.index(configatron.elasticsearch.indices.spree_products).refresh

            recommended_for_style_profile(style_profile, limit)
          end
        end
      end
    end
  end
end

Spree::Product.send(:include, Overrides::Spree::Product)
