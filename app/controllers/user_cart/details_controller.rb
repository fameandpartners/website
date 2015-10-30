class UserCart::DetailsController < UserCart::BaseController
  respond_to :html, :json, :js
  before_filter :set_user_cart

  def order_delivery_date
    render json: Policies::ProjectDeliveryDatePolicy.order_delivery_date(@user_cart)
  end

  def show
    check_authorization

    #title('Your Shopping Cart', default_seo_title)

    respond_with(@user_cart) do |format|
      format.html   {}
      format.json   {
        render json: @user_cart.serialize, status: :ok
      }
    end
  end

  def set_user_cart
    @user_cart = user_cart_resource.read
  end
end
