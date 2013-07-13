module Products
  class ProductsFilter
    attr_accessor :properties
    attr_accessor :current_user
    attr_accessor :current_currency

    class << self
      def available_orders
        [
          ['price_high', 'Price High'],
          ['price_low', 'Price Low'],
          ['newest', "What's new"],
          ['popular', 'popular']
        ]
      end
    end

    def initialize(params)
      self.current_currency = Spree::Config[:currency]
      @properties = {}
      prepare(HashWithIndifferentAccess.new(params))
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

    protected
    def get_base_scope
      base_scope = Spree::Product.active
      # has options modify already applied scopes.
      base_scope = add_color_scope(base_scope)

      base_scope = add_taxonomy_scope(base_scope)
      base_scope = get_products_conditions_for(base_scope, keywords)
      base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]
      base_scope = add_search_scopes(base_scope)

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
      return base_scope if colors.blank?
      base_scope = base_scope.has_options(Spree::Variant.color_option_type, colors)
    end

    def add_taxonomy_scope(base_scope)
      return base_scope if taxons.blank?
      # simple taxon_id in (...) condition
      if taxons.keys.length == 1
        return base_scope.in_taxons(taxons.values.flatten)
      end
      # here we should search products which have taxons from both or more sets of taxons
      query = nil
      taxons.each do |name, taxon_or_taxons|
        if taxon_or_taxons.is_a?(ActiveRecord::Relation) or taxon_or_taxons.is_a?(Array)
          ids = taxon_or_taxons.map(&:id).join(',')
        else
          ids = taxon_or_taxons.id
        end

        if query.blank? # first level, without subquery
          query = "select distinct(product_id) 
                   from spree_products_taxons 
                   where taxon_id in (#{ids})"
        else
          query = "select distinct(product_id) 
                   from spree_products_taxons 
                   where taxon_id in (#{ids})
                    and product_id in (#{query})"
        end
      end
      product_ids = Spree::Classification.find_by_sql(query).map(&:product_id)

      base_scope.where(id: product_ids)
    end

    def add_order_scope(base_scope)
      return base_scope if order.blank?
      case order
      when 'price_high'
        base_scope.order("spree_prices.amount desc")
      when 'price_low'
        base_scope.order("spree_prices.amount asc")
      when 'newest'
        base_scope.order('created_at desc')
      when 'popular'
        base_scope
      else
        base_scope
      end
    end

    def prepare(params)
      @properties[:taxons] = prepare_taxons(params[:taxons]) 
      @properties[:keywords] = params[:keywords]
      @properties[:search] = params[:search]
      @properties[:colors] = params[:colors]

      per_page = params[:per_page].to_i
      @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
      @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
      @properties[:order] = params[:order]
    end

    def prepare_taxons(args)
      return {} if args.blank?
      {}.tap do |taxons|
        args.each do |taxon_key, taxon_id_or_ids|
          taxons[taxon_key] = Spree::Taxon.where(id: taxon_id_or_ids)
        end
      end
    end
  end
end
