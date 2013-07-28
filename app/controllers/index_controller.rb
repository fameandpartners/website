class IndexController < Spree::StoreController
  layout 'spree/layouts/spree_application'
  helper 'spree/taxons'

  respond_to :html 

  def show
    if params[:workshop]
      session[:sign_up_reason] = 'workshop'
    end

    @featured_products = Spree::Product.active.featured.uniq
  end
end
