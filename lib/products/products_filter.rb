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
          ['newest', "What's new"]
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

    def retrieve_products
      color_ids  = colors_with_similar.present? ? colors_with_similar.map(&:id) : []
      taxon_ids  = taxons.present? ? taxons : {}
      keywords   = keywords.present? ? keywords.split : []
      bodyshapes = bodyshape
      order_by   = order
      limit      = per_page
      offset     = ((page - 1) * per_page)

      Tire.search(:spree_products, load: { include: { master: :prices } }) do
        # Filter only undeleted & available products
        filter :bool, :must => { :term => { :deleted => false } }
        filter :exists, :field => :available_on
        filter :bool, :should => {
          :range => {
            :available_on => { :lte => Time.now }
          }
        }

        # Filter by colors
        if color_ids.present?
          filter :terms, :color_ids => color_ids
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

    def colors_with_similar
      similar_colors = colour.map(&:similars).flatten
      colour + similar_colors
    end

    protected

    def taxons
      permalinks = Spree::Taxon.roots.map(&:permalink)
      @properties.slice(*permalinks).reject{ |k, v| v.blank? }
    end

    def prepare(params)
      params = HashWithIndifferentAccess.new(params) unless params.is_a?(HashWithIndifferentAccess)
      @properties[:keywords] = params[:keywords]

      # this block works as proxy, between human readable url params like 'red', 'skirt'
      # and required for search ids
      @properties[:collection]  ||= []
      @properties[:edits]       ||= []
      Spree::Taxon.roots.each do |taxon|
        permalink = taxon.permalink
        @properties[permalink] = prepare_taxon(permalink, params[permalink])
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
    def prepare_taxon(root, permalinks)
      return nil if permalinks.blank?
      permalinks = Array.wrap(permalinks)

      db_permalinks = permalinks.map{|permalink| "#{root}/#{permalink.downcase}"}
      Spree::Taxon.select(:id).where("lower(permalink) IN (?)", db_permalinks).map(&:id)
    end

    def prepare_colours(colour_names)
      return [] if colour_names.blank?
      colours = Array.wrap(colour_names).collect{|colour| colour.to_s.downcase.split(/[_-]/).join(' ')}
      Spree::OptionValue.where("lower(name) in (?)", colours).to_a
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
