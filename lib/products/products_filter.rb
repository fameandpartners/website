module Products
  class ProductsFilter
    attr_accessor :properties
    attr_accessor :current_user
    attr_accessor :current_currency

    def initialize(params)
      self.current_currency = Spree::Config[:currency]
      @properties = {}
      prepare(params)
    end

    def retrieve_products
      @products_scope = get_base_scope
      curr_page = page || 1

      @products = @products_scope.includes([:master => :prices])
      unless Spree::Config.show_products_without_price
        @products = @products.where("spree_prices.amount IS NOT NULL").where("spree_prices.currency" => current_currency)
      end
      @products = @products.page(curr_page).per(per_page)
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
      unless taxons.blank?
        taxons.each do |taxon_name, taxon_or_taxons|
          base_scope = base_scope.in_taxons(taxon_or_taxons)
        end
      end
      base_scope = get_products_conditions_for(base_scope, keywords)
      base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]
      base_scope = add_search_scopes(base_scope)
      base_scope = add_color_scope(base_scope)

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
      base_scope.has_options(Spree::Variant.color_option_type, colors)
    end

    def prepare(params)
      @properties[:taxons] = prepare_taxons(params[:taxons]) 
      @properties[:keywords] = params[:keywords]
      @properties[:search] = params[:search]
      @properties[:colors] = params[:colors]

      per_page = params[:per_page].to_i
      @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
      @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
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
