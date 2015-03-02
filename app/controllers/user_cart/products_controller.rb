class UserCart::ProductsController < UserCart::BaseController
  respond_to :json

  # {"size_id"=>"34", "color_id"=>"89", "customizations_ids"=>"", "variant_id"=>"19565"}
  def create
    cart_populator = UserCart::Populator.new(
      order: current_order(true),
      site_version: current_site_version,
      currency: current_currency,
      product: {
        variant_id: params[:variant_id],
        size_id: params[:size_id],
        color_id: params[:color_id],
        customizations_ids: params[:customizations_ids],
        quantity: 1
      }
    )
    result = cart_populator.populate

    if result.success
      if spree_user_signed_in? && current_order.user.nil?
        self.extend(Spree::Core::ControllerHelpers::Order)
        associate_user
      end

      # spree promotion requires call from controller. crude&unclear, needs cleanup
      if current_promotion.present?
        @order = current_order
        @order.update_attributes(coupon_code: current_promotion.code)
        apply_coupon_code
        fire_event('spree.order.contents_changed')
        current_order.reload
      end

      Activity.log_product_added_to_cart(
        result.product, temporary_user_key, try_spree_current_user, current_order
      )
    end

    @user_cart = user_cart_resource.read

    respond_with(@user_cart) do |format|
      format.json   { 
        render json: @user_cart.serialize, status: :ok
      }
    end
  end

  def update
    line_item = current_order.line_items.find(params[:id])
    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1
    variant = Spree::Variant.find(params[:variant_id])

    current_order.update_line_item(line_item, variant, quantity, currency = nil)
    current_order.reload!

    @user_cart = user_cart_resource.read

    respond_with(@user_cart) do |format|
      format.json   { 
        render json: @user_cart.serialize, status: :ok
      }
    end
  rescue
    respond_with({}) do |format|
      format.json  json: {}, status: :error 
    end
  end

  def destroy
    line_item = current_order.line_items.where(id: params[:id]).first
    line_item.try(:destroy)
    current_order.reload

    render json: user_cart_resource.read.serialize, status: :ok
  end
end
