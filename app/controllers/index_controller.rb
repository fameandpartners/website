class IndexController < Spree::StoreController
  layout 'spree/layouts/spree_application'
  helper 'spree/taxons'

  respond_to :html 

  # Products::Filter ?
  # Products::ColorsSearcher ?
  def show
    @searcher = Products::ProductsFilter.new(params)
    @searcher.current_user = try_spree_current_user
    @searcher.current_currency = current_currency
    @products = @searcher.retrieve_products

    @featured_products = Spree::Product.limit(6)

    all_products = [@products, @featured_products].to_a.flatten
    @colors = Products::ColorsSearcher.new(all_products).retrieve_colors

    respond_with @products
  end
end
