class UserCart::PromotionsController < UserCart::BaseController
  respond_to :json

  def create
    UserCart::PromotionsService.new(
      site_version: current_site_version,
      order: current_order,
      code: params[:promotion_code]
    ).apply

    @user_cart = user_cart_resource.read
    respond_with(@user_cart) do |format|
      format.html   {}
      format.json   { 
        render json: @user_cart.serialize, status: :ok
      }
    end
  end
end
