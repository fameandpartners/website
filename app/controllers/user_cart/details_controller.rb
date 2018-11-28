class UserCart::DetailsController < Api::ApiBaseController
  respond_to :json

  def show    
    respond_with do |format|
      format.json   {
        render json:
        {
          cart: OrderSerializer.new(current_order).as_json,
          user: spree_user_signed_in? && UserSerializer.new(current_spree_user)
        },
       status: :ok
      }
    end
  end
end
