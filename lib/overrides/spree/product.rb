module Overrides
  module Spree
    module Product
      extend ActiveSupport::Concern

      included do
        include Tire::Model::Search
        #include Tire::Model::Callbacks

        has_one :style_profile,
                :class_name => '::ProductStyleProfile',
                :foreign_key => :product_id

        mapping do
          indexes :id, :index => :not_analyzed
          indexes :name, :analyzer => :snowball
          indexes :description, :analyzer => :snowball
          indexes :taxons, :as => 'taxons.map(&:name)'
          indexes :colors, :as => 'colors'
          indexes :glam, :type => :float, :as => 'style_profile.glam'
          indexes :girly, :type => :float, :as => 'style_profile.girly'
          indexes :classic, :type => :float, :as => 'style_profile.classic'
          indexes :edgy, :type => :float, :as => 'style_profile.edgy'
          indexes :bohemian, :type => :float, :as => 'style_profile.bohemian'
          indexes :apple, :type => :float, :as => 'style_profile.apple'
          indexes :pear, :type => :float, :as => 'style_profile.pear'
          indexes :strawberry, :type => :float, :as => 'style_profile.strawberry'
          indexes :hour_glass, :type => :float, :as => 'style_profile.hour_glass'
          indexes :column, :type => :float, :as => 'style_profile.column'
          indexes :bra_aaa, :type => :float, :as => 'style_profile.bra_aaa'
          indexes :bra_aa, :type => :float, :as => 'style_profile.bra_aa'
          indexes :bra_a, :type => :float, :as => 'style_profile.bra_a'
          indexes :bra_b, :type => :float, :as => 'style_profile.bra_b'
          indexes :bra_c, :type => :float, :as => 'style_profile.bra_c'
          indexes :bra_d, :type => :float, :as => 'style_profile.bra_d'
          indexes :bra_e, :type => :float, :as => 'style_profile.bra_e'
          indexes :bra_fpp, :type => :float, :as => 'style_profile.bra_fpp'
          indexes :sexiness, :type => :float, :as => 'style_profile.sexiness'
          indexes :fashionability, :type => :float, :as => 'style_profile.fashionability'
        end

        before_create do
          build_style_profile
        end
      end

      SORT_SCRIPT =
        %q{
          sqrt(
            (
              (doc['glam'].value - %{glam}) ** 2
            ) + (
              (doc['girly'].value - %{girly}) ** 2
            ) + (
              (doc['classic'].value - %{classic}) ** 2
            ) + (
              (doc['edgy'].value - %{edgy}) ** 2
            ) + (
              (doc['apple'].value - %{apple}) ** 2
            ) + (
              (doc['pear'].value - %{pear}) ** 2
            ) + (
              (doc['strawberry'].value - %{strawberry}) ** 2
            ) + (
              (doc['hour_glass'].value - %{hour_glass}) ** 2
            ) + (
              (doc['column'].value - %{column}) ** 2
            ) + (
              (doc['bra_aaa'].value - %{bra_aaa}) ** 2
            ) + (
              (doc['bra_aa'].value - %{bra_aa}) ** 2
            ) + (
              (doc['bra_a'].value - %{bra_a}) ** 2
            ) + (
              (doc['bra_b'].value - %{bra_b}) ** 2
            ) + (
              (doc['bra_c'].value - %{bra_c}) ** 2
            ) + (
              (doc['bra_d'].value - %{bra_d}) ** 2
            ) + (
              (doc['bra_e'].value - %{bra_e}) ** 2
            ) + (
              (doc['bra_fpp'].value - %{bra_fpp}) ** 2
            ) + (
              (doc['sexiness'].value - %{sexiness}) ** 2
            ) + (
              (doc['fashionability'].value - %{fashionability}) ** 2
            )
          );
        }.gsub(/[\r\n]|([\s]{2,})/, '')

      module ClassMethods
        def recommended_for(user)
          style_profile = UserStyleProfile.find_by_user_id(user.id)

          query = Tire.search(:spree_products, :page => 1, :load => true) do
            sort do
              by ({
                :_script => {
                  :script => SORT_SCRIPT % {
                    :glam => style_profile.glam,
                    :girly => style_profile.girly,
                    :classic => style_profile.classic,
                    :edgy => style_profile.edgy,
                    :bohemian => style_profile.bohemian,
                    :apple => style_profile.apple,
                    :pear => style_profile.pear,
                    :strawberry => style_profile.strawberry,
                    :hour_glass => style_profile.hour_glass,
                    :column => style_profile.column,
                    :bra_aaa => style_profile.bra_aaa,
                    :bra_aa => style_profile.bra_aa,
                    :bra_a => style_profile.bra_a,
                    :bra_b => style_profile.bra_b,
                    :bra_c => style_profile.bra_c,
                    :bra_d => style_profile.bra_d,
                    :bra_e => style_profile.bra_e,
                    :bra_fpp => style_profile.bra_fpp,
                    :sexiness => style_profile.sexiness,
                    :fashionability => style_profile.fashionability
                  },
                  type:   'number',
                  order:  'asc'
                }
              })
            end

            from 0
            size 12
          end

          query.results.results
        end
      end
    end
  end
end

Spree::Product.send(:include, Overrides::Spree::Product)
