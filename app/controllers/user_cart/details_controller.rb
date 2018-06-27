class UserCart::DetailsController < UserCart::BaseController
  respond_to :json
  before_filter :set_user_cart

  def order_delivery_date
    render json: Policies::ProjectDeliveryDatePolicy.order_delivery_date(@user_cart)
  end

  def show
    check_authorization

    #title('Your Shopping Cart', default_seo_title)

    user = current_spree_user.clone
    user[:is_admin] = current_spree_user.try(:has_spree_role?, "admin") 
    
    respond_with(@user_cart) do |format|
      format.html   {}
      format.json   {
        render json:
        {
          cart: @user_cart.serialize,
          user: spree_user_signed_in? && user
        },
       status: :ok
      }
    end
  end

  def set_user_cart
    current_order.updater.update_totals
    @user_cart = user_cart_resource.read
  end
end
