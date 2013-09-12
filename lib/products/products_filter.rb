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
      @products_scope = get_base_scope

      @products = @products_scope.includes([:master => :prices])
      unless Spree::Config.show_products_without_price
        @products = @products.where("spree_prices.amount IS NOT NULL").where("spree_prices.currency" => current_currency)
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
      Products::BannerInfo.new(collection).get
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
      base_scope = base_scope.has_options(Spree::Variant.color_option_type, colour)
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
          condition.push("product_style_profiles.#{shape} > 0")
        end
      end.join(' or ')

      #joins_string = "LEFT OUTER JOIN product_style_profiles ON spree_products.id = product_style_profiles.product_id"
      base_scope.joins(:style_profile).where("(#{conditions})")
    end

    def add_order_scope(base_scope)
      return base_scope if order.blank? && bodyshape.blank?

      case order
      when 'price_high'
        ordered_scope = base_scope.order('spree_prices.amount desc')
      when 'price_low'
        ordered_scope = base_scope.order('spree_prices.amount asc')
      when 'newest'
        ordered_scope = base_scope.order('spree_products.created_at desc')
      when 'popular'
        ordered_scope = base_scope
      else
        ordered_scope = base_scope
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
      @properties[:collection] ||= []
      Spree::Taxon.roots.each do |taxon|
        permalink = taxon.permalink
        @properties[permalink] = prepare_taxon(permalink, params[permalink])
      end

      @properties[:colour]      = prepare_colours(params[:colour])
      @properties[:bodyshape]   = prepare_bodyshape(params[:bodyshape])
      # eo proxy

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

      db_permalinks = permalinks.map{|permalink| "#{root}/#{permalink}"}
      Spree::Taxon.select(:id).where(permalink: db_permalinks).map(&:id)
    end

    def prepare_colours(colour_names)
      return nil if colour_names.blank?
      Spree::OptionValue.where(name: colour_names).to_a
    end

    def prepare_bodyshape(bodyshapes)
      return nil if bodyshapes.blank?
      bodyshapes = [bodyshapes] unless bodyshapes.is_a?(Array)
      bodyshapes.map(&:downcase)
    end
  end
end
