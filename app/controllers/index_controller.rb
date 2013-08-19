class IndexController < Spree::StoreController
  layout 'spree/layouts/spree_application'
  helper 'spree/taxons'

  respond_to :html 

  def show
    if params[:workshop]
      session[:sign_up_reason] = 'workshop'
    end
  end

  private

  def featured_products
    @featured_products ||= Spree::Product.active.featured.uniq.includes(:master)
  end

  helper_method :featured_products
end
