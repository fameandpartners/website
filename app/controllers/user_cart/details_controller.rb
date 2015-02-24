class UserCart::DetailsController < UserCart::BaseController
  respond_to :html, :json, :js

  def show
    check_authorization

    @user_cart = user_cart_resource.read

    #title('Your Shopping Cart', default_seo_title)

    respond_with(@user_cart) do |format|
      format.html   {}
      format.json   { 
        render json: @user_cart.serialize, status: :ok
      }
    end
  end

  # apply coupon only?
  def update
  end
end
