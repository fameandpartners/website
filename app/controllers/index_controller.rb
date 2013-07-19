class IndexController < Spree::StoreController
  layout 'spree/layouts/spree_application'
  helper 'spree/taxons'

  respond_to :html 

  def show
    @featured_products = Spree::Product.active.featured
    @colors = Products::ColorsSearcher.new(@featured_products).retrieve_colors
  end
end
