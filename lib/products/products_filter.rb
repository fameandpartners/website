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
      color_ids  = colour.present? ? colour.map(&:id) : []
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
                  intersection_size = 0;
                  foreach(color_id : color_ids) {
                    foreach(viewable_color_id : doc['viewable_color_ids'].values) {
                      if (viewable_color_id == color_id) {
                        intersection_size = intersection_size + 1;
                      }
                    }
                  }
                  intersection_size
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
        end

        from offset
        size limit
      end.results.results
    end

    def retrieve_products_old
      @products_scope = get_base_scope
      @products = @products_scope.includes(:master => :prices).scoped
      unless Spree::Config.show_products_without_price
        # note - we don't count different currencies here
        @products = @products.joins(
          "LEFT OUTER JOIN spree_zone_prices ON spree_zone_prices.variant_id = spree_variants.id"
        )
        @products = @products.where("(spree_prices.amount IS NOT NULL) or (spree_zone_prices.amount is not null)")
      end
      @products.offset((page - 1) * per_page).limit(per_page)
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

    protected

    def get_base_scope
      base_scope = Spree::Product.active
      # has options modify already applied scopes.
      base_scope = add_color_scope(base_scope)

      base_scope = add_taxonomy_scope(base_scope)
      base_scope = get_products_conditions_for(base_scope, keywords)
      base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]
      base_scope = add_search_scopes(base_scope)

      base_scope = add_bodyshape_scope(base_scope)

      base_scope = add_order_scope(base_scope)

      base_scope
    end

    def add_search_scopes(base_scope)
      search.each do |name, scope_attribute|
        scope_name = name.to_sym
        if base_scope.respond_to?(:search_scopes) && base_scope.search_scopes.include?(scope_name.to_sym)
          base_scope = base_scope.send(scope_name, *scope_attribute)
        else
          base_scope = base_scope.merge(Spree::Product.search({scope_name => scope_attribute}).result)
        end
      end if search
      base_scope
    end

    # method should return new scope based on base_scope
    def get_products_conditions_for(base_scope, query)
      unless query.blank?
        base_scope = base_scope.like_any([:name, :description], query.split)
      end
      base_scope
    end

    def add_color_scope(base_scope)
      return base_scope if colour.blank?
      base_scope.has_options(Spree::Variant.color_option_type, colour)
    end

    def add_taxonomy_scope(base_scope)
      return base_scope if taxons.blank?
      # simple taxon_id in (...) condition

      if taxons.keys.length == 1
        return base_scope.in_taxons(taxons.values.flatten)
      end
      # here we should search products which have taxons from both or more sets of taxons
      query = nil
      taxons.each do |name, ids|
        if query.blank? # first level, without subquery
          query = "select distinct(product_id)
                   from spree_products_taxons
                   where taxon_id in (#{ids.join(',')})"
        else
          query = "select distinct(product_id)
                   from spree_products_taxons
                   where taxon_id in (#{ids.join(',')})
                    and product_id in (#{query})"
        end
      end
      product_ids = Spree::Classification.find_by_sql(query).map(&:product_id)

      base_scope.where(id: product_ids)
    end

    def add_bodyshape_scope(base_scope)
      return base_scope if bodyshape.blank?
      conditions = [].tap do |condition|
        bodyshape.each do |shape|
          condition.push("product_style_profiles.#{shape} > 4")
        end
      end.join(' or ')

      #joins_string = "LEFT OUTER JOIN product_style_profiles ON spree_products.id = product_style_profiles.product_id"
      base_scope.joins(:style_profile).where("(#{conditions})")
    end

    def add_order_scope(base_scope)
      return base_scope if colour.blank? && order.blank? && bodyshape.blank?

      ordered_scope = base_scope

      case order
      when 'price_high'
        ordered_scope = ordered_scope.order('spree_prices.amount desc')
      when 'price_low'
        ordered_scope = ordered_scope.order('spree_prices.amount asc')
      when 'newest'
        ordered_scope = ordered_scope.order('spree_products.created_at desc')
      when 'popular'
        ordered_scope = ordered_scope
      else
        ordered_scope = ordered_scope
      end

      if bodyshape.present?
        ordered_scope = ordered_scope.order(bodyshape.map{|shape| %Q{"product_style_profiles"."#{shape}"} }.join(' + ') + ' DESC')
      end

      ordered_scope
    end

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
      return nil if colour_names.blank?
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
