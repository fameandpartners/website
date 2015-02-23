class UserCart::DetailsController < UserCart::BaseController
  respond_to :html, :json, :js

  def show
    check_authorization

    @user_cart = UserCart::UserCartResource.new(
      order: current_order,
      site_version: current_site_version
    ).read

    #title('Your Shopping Cart', default_seo_title)

    respond_with(@user_cart) do |format|
      format.html   {}
      format.json   { 
        render json: @user_cart.serialize
      }
    end
  end

  # apply coupon only?
  def update
  end
end

# 2036515
    UserCart::UserCartResource.new(order: Spree::Order.find(2036515)).read
