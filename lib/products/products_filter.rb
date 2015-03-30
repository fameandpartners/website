module Products
  class ProductsFilter
    attr_accessor :properties
    attr_accessor :current_user
    attr_accessor :current_currency

    class << self
      def available_sort_orders
        [
          ['price_high', 'Price High'],
          ['price_low', 'Price Low'],
          ['newest', "What's new"],
          ['fast_delivery', 'Next day delivery']
        ]
      end

      def available_body_shapes
        ProductStyleProfile::BODY_SHAPES
      end
    end

    def initialize(params)
      self.current_currency = Spree::Config[:currency]
      @properties = ActiveSupport::HashWithIndifferentAccess.new
      prepare(params)
    end

    # all product, or near exact matched to colour
    def products
      @products ||= begin
        if colour.blank?
          search
        else
          search(colors_with_similar(:very_close).map(&:id), only_viewable_colors: true)
        end
      end
    end

    def similar_products
      @similar_products ||= begin
        if colour.blank?
          []
        else
          @fetched_products_ids = products.map(&:id)
          search(colors_with_similar(:default).map(&:id))
        end
      end
    end

    def search(color_ids = [], options = {})
      taxon_ids  = taxons.present? ? taxons : {}
      keywords   = keywords.present? ? keywords.split : []
      bodyshapes = bodyshape
      order_by   = order
      limit      = per_page
      offset     = ((page - 1) * per_page)
      fetched_products_ids = @fetched_products_ids
      only_viewable_colors = options[:only_viewable_colors]

      begin
        Tire.search(:spree_products, load: { include: { master: :prices } }) do
          # Filter only undeleted & available products
          filter :bool, :must => { :term => { :deleted => false } }
          filter :bool, :must => { :term => { :hidden => false } }
          filter :exists, :field => :available_on
          filter :bool, :should => {
            :range => {
              :available_on => { :lte => Time.now }
            }
          }

          if fetched_products_ids.present?
            filter :bool, :must => {
              :not => {
                :terms => {
                  :id => fetched_products_ids
                }
              }
            }
          end

          # Filter by colors
          if color_ids.present?
            if only_viewable_colors
              filter :terms, :viewable_color_ids => color_ids
            else
              filter :terms, :color_ids => color_ids
            end
          end

          # Filter by taxons
          if taxon_ids.present?
            taxon_ids.each do |scope_name, ids|
              filter :terms, :taxon_ids => ids
            end
          end

          # Filter by keywords
          query :term, :name => keywords if keywords.present?
          query :term, :description => keywords if keywords.present?

          # Show only products from stock
          filter :bool, :must => { :term => { :in_stock => true } }

          # Show only products with prices
          unless Spree::Config.show_products_without_price
            filter :exists, :field => :price
          end


          # Filter by bodyshapes
          if bodyshapes.present?
            if bodyshapes.size.eql?(1)
              filter :bool, :should => {
                :range => {
                  bodyshapes.first.to_sym => {
                    :gte => 4
                  }
                }
              }
            else
              filter :or,
                *bodyshapes.map do |bodyshape|
                  {
                    :bool => {
                      :should => {
                        :range => {
                          bodyshape.to_sym => {
                            :gte => 4
                          }
                        }
                      }
                    }
                  }
                end
            end
          end

          sort do
            if color_ids.present?
              by ({
                :_script => {
                  script: %q{
                    int intersection_size = 0;

                    if (doc.containsKey('viewable_color_ids')) {
                      for ( int i = 0; i < color_ids.size(); i++ ) {
                        color_id = color_ids[i];

                        foreach( viewable_color_id : doc['viewable_color_ids'].values ) {
                          if ( viewable_color_id == color_id ) {
                            intersection_size += 1;
                          }
                        }

                        if ( intersection_size > 0 ) {
                          return color_ids.size() + color_ids.size() - i;
                        }
                      }
                    }

                    if (doc.containsKey('color_ids')) {
                      for ( int i = 0; i < color_ids.size(); i++ ) {
                        color_id = color_ids[i];

                        foreach( doc_color_id : doc['color_ids'].values ) {
                          if ( doc_color_id == color_id ) {
                            intersection_size += 1;
                          }
                        }

                        if ( intersection_size > 0 ) {
                          return color_ids.size() - i;
                        }
                      }
                    }

                    return 0;
                  }.gsub(/[\r\n]|([\s]{2,})/, ''),
                  params: {
                    color_ids: color_ids
                  },
                  type: 'number',
                  order: 'desc'
                }
              })
            end

            if bodyshapes.present?
              by ({
                :_script => {
                  script: bodyshapes.map{|bodyshape| "doc['#{bodyshape}'].value" }.join(' + '),
                  type:   'number',
                  order:  'desc'
                }
              })
            end

            case order_by
              when 'price_high'
                by :price, 'desc'
              when 'price_low'
                by :price, 'asc'
              when 'newest'
                by :created_at, 'desc'
              when 'fast_delivery'
                by :fast_delivery, 'desc'
              when 'popular'
                # default ordering scope
              else
                # default ordering scope
            end

            by :position, 'asc'
          end

          from offset
          size limit
        end.results.results
      rescue ActiveRecord::RecordNotFound
        Tire.index(:spree_products) do
          delete
          import ::Spree::Product.all
        end

        Tire.index(:spree_products).refresh

        search
      end
    end

    def method_missing(name)
      if @properties.has_key? name
        @properties[name]
      else
        super
      end
    end

    def selected_products_info
      info = Products::BannerInfo.new(self).get
    end

    def colors_with_similar(range = :default)
      return [] if colour.blank?
      max_diff = range == :very_close ? 15 : 30

      similar_colors = colour.map do |colour|
        colour.similars.where('similarities.coefficient < ?', max_diff)
      end.flatten
      colour + similar_colors
    end

    def selected_color_name
      colour.present? ? colour.first.name : nil
    end

    protected

    def taxons
      permalinks = Spree::Taxon.all.map(&:permalink)

      # * = splat operator
      # slice limits the hash to hold only provided values

      @properties.slice(*permalinks).reject{ |k, v| v.blank? }
    end

    def prepare(params)
      params = HashWithIndifferentAccess.new(params) unless params.is_a?(HashWithIndifferentAccess)
      @properties[:keywords] = params[:keywords]

      # this block works as proxy, between human readable url params like 'red', 'skirt'
      # and required for search ids
      @properties[:collection]  ||= []
      @properties[:edits]       ||= []

      @properties[:selected_taxons] ||= []
      @properties[:selected_edits] ||= []

      # it's dirty hack, we equal collection with some other collection
      if params[:collection].present? && params[:seocollection].blank?
        params[:seocollection] = params[:collection]
        @properties["collection"] = params[:collection]
        @properties["seocollection"] = params[:collection]
        # MarkoK: continuing with dirty hacks, to ensure backwards compatibility
        # with the old links, we add "collection/" to the beggining of the permalink
        params[:permalink] = "collection/#{params[:collection]}"
      elsif params[:collection].present?
        params[:permalink] = "collection/#{params[:collection]}"
        @properties["collection"] = params[:collection]
      elsif params[:edits].present?
        params[:permalink] = "edits/#{params[:edits]}"
      elsif params[:collection].blank? && params[:edits].blank? && params[:permalink].present?
        params[:permalink].downcase!
        # chop off the end part of a permalink (after "/")
        params[:collection] = params[:permalink].split("/")[1]
        params[:seocollection] = params[:collection]
        @properties["collection"] = params[:collection]
        @properties["seocollection"] = params[:collection]
      end

        # ugly, refactros ASAP
        params[:permalink].downcase! unless params[:permalink].blank?

        # adding support for faceted search (filtering) across multiple taxons
        final_requested_taxons = []
        final_requested_taxons << params[:permalink] unless params[:permalink].blank?
        final_requested_taxons << "style/#{params[:style]}" unless params[:style].blank?
        final_requested_taxons << "event/#{params[:event]}" unless params[:event].blank?

      Spree::Taxon.all.each do |taxon|
        permalink = taxon.permalink
        @properties[permalink] = prepare_taxon(permalink, final_requested_taxons)
        if @properties[permalink].present? && params[:edits].blank?
          @properties[:selected_edits] << @properties[permalink]
        elsif @properties[permalink].present?
          @properties[:selected_taxons] << @properties[permalink]
        end
      end

      @properties[:colour]        = prepare_colours(params[:colour])
      @properties[:seo_colour]    = prepare_seo_colour(params[:colour])
      @properties[:bodyshape]     = prepare_bodyshape(params[:bodyshape])

      @properties[:search] = params[:search]

      per_page = params[:per_page].to_i
      @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
      @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
      @properties[:order] = params[:order]
    end

    # get by permalinks. array or single param
    # todo: create root taxon - independed search
    def prepare_taxon(taxon_permalink, requested_permalinks)
      return nil if requested_permalinks.blank?
      permalinks = Array.wrap(requested_permalinks)

      # db_permalinks = permalinks.map{|permalink| "#{root}/#{permalink.downcase}"}
      # Spree::Taxon.select(:id).where("lower(permalink) IN (?)", db_permalinks).map(&:id)
      if permalinks.include? taxon_permalink
        r = Spree::Taxon.select(:id).where(permalink: taxon_permalink).map(&:id)
      else
        r = nil
      end

      return r
    end

    def prepare_colours(colour_names)
      return [] if colour_names.blank?
      colours = Array.wrap(colour_names).collect{|colour| colour.to_s.downcase }

      if colours.size.eql?(1)
        color_names = case colours.first
          when 'blue'
            %w( blue navy )
          when 'pink'
            %w( pink blush-pink )
          when 'red'
            %w( red burgundy )
          when 'pastel'
            %w( aqua nude lilac pale-blue pale-pink pale-grey pale-lavender pale-blush blush peach cream-and-blue dusty-pink silver sherbet blush-pink lavender shell )
          else
            colours
        end
      else
        color_names = colours
      end

      if color_names.size.eql?(1)
        Spree::OptionValue.where("lower(name) = ?", color_names.first).to_a
      else
        whens = color_names.map do |color_name|
          "WHEN lower(name) = #{ActiveRecord::Base.connection.quote(color_name)} THEN #{color_names.index(color_name)}"
        end

        ordering_sql = "CASE #{whens.join(' ')} END ASC"

        Spree::OptionValue.
          where("lower(name) IN (?)", color_names).
          order(ordering_sql).
          to_a
      end
    end

    def prepare_bodyshape(bodyshapes)
      return nil if bodyshapes.blank?
      bodyshapes = [bodyshapes] unless bodyshapes.is_a?(Array)
      bodyshapes.map(&:downcase)
    end

    def prepare_seo_colour(colour_names)
      (Array.wrap(colour_names) || []).first.to_s.downcase.split(/[_-]/).compact.join(' ')
    end
  end
end
