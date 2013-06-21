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
    @searcher = ProductsFilter.new(params)
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products

    if request.xhr?
      text = render_to_string(partial: 'products', locals: { products: @products })
      render text: text, layout: false
    else
      render action: 'index', layout: true
    end
  end
end
