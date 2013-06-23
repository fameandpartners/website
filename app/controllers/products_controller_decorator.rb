Spree::ProductsController.class_eval do
  #before_filter :load_data,  only: :some_action

#  def index
#    @searcher = Config.searcher_class.new(params)
#    @searcher.current_user = try_spree_current_user
#    @searcher.current_currency = current_currency
#    @products = @searcher.retrieve_products
#    respond_with(@products)
#  end

  def index
    @searcher = Products::ProductsFilter.new(params)
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products

    if request.xhr?
      @featured_products = Spree::Product.limit(6)
      all_products = [@products, @featured_products].to_a.flatten
      @colors = Products::ColorsSearcher.new(all_products).retrieve_colors

      text = render_to_string(partial: 'products', locals: { products: @products, colors: @colors })
      render text: text, layout: false
    else
      @colors = Products::ColorsSearcher.new(@producs).retrieve_colors
      render action: 'index', layout: true
    end
  end

  # NOTE: original method check case when user comes from page
  # with t= params and load corresponding taxon
  def show
    return unless @product

    @variants = @product.variants_including_master.active(current_currency).includes([:option_values, :images])
    @product_properties = @product.product_properties.includes(:property)

    @similar_products = Spree::Product.limit(4)

    respond_with(@product)
  end
end
