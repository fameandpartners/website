class UserCart::DetailsController < Api::ApiBaseController
  respond_to :json

  def show    
    current_order&.hydrate

    respond_with do |format|
      format.json   {
        render json:
        {
          cart: current_order ? OrderSerializer.new(current_order, default_serializer_options).as_json : nil,
          user: spree_user_signed_in? ? UserSerializer.new(current_spree_user, default_serializer_options).as_json : nil
        },
       status: :ok
      }
    end
  end
end
