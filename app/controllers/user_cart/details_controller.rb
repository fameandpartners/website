class UserCart::DetailsController < Api::ApiBaseController
  respond_to :json

  def show    
    respond_with(@user_cart) do |format|
      format.html   {}
      format.json   {
        render json:
        {
          cart: user_cart_resource.read.serialize,
          user: spree_user_signed_in? && UserSerializer.new(current_spree_user)
        },
       status: :ok
      }
    end
  end

  def user_cart_resource
    @cart_resource ||= UserCart::UserCartResource.new(
      order: current_order,
      site_version: current_site_version
    )
  end
end
