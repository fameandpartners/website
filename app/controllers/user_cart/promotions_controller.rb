class UserCart::PromotionsController < UserCart::BaseController
  include SslRequirement
  ssl_allowed

  respond_to :json

  def create
    service = UserCart::PromotionsService.new(
      order: current_order,
      code: params[:promotion_code]
    )

    if service.apply
      fire_event('spree.order.contents_changed')
      fire_event('spree.checkout.coupon_code_added')

      @user_cart = user_cart_resource.read

      respond_with(@user_cart) do |format|
        format.json { render json: @user_cart.serialize, status: :ok }
      end
    else
      respond_with({}) do |format|
        format.json { render json: { error: service.message }, status: :ok }
      end
    end
  end
end
