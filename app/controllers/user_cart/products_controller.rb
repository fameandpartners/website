class UserCart::ProductsController < UserCart::BaseController
  respond_to :json
  protect_from_forgery except: [:create, :destroy]
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
        stock: params[:stock],
        fabric_id: params[:fabric_id],
        customizations_ids: params[:customizations_ids],
        making_options_ids: params[:making_options_ids],
        height:             params[:height],
        height_value:       params[:height_value],
        height_unit:        params[:height_unit],
        curation_name:      params[:curation_name],
        quantity: 1
      }
    )
    result = cart_populator.populate

    if result.success
      if spree_user_signed_in? && current_order.user.nil?
        self.extend(Spree::Core::ControllerHelpers::Order)
        associate_user
      end

      current_order.hydrate
      
      respond_with(current_order) do |format|
        format.json   {
          render json: current_order, serializer: OrderSerializer, status: :ok
        }
      end
    else # not success
      NewRelic::Agent.notify('AddToCartFailed',
                             message: result.message,
                             order_number: current_order.number,
                             site_version: current_site_version.code,
                             attrs: result.attrs)
      respond_with({}) do |format|
        format.json   {
          render json: { error: true, message: result.message, attrs: result.attrs }, status: 422
        }
      end
    end
  end

  def create_line_item_making_option
    line_item = current_order(true).line_items.find(params[:line_item_id])
    line_item.making_options.each(&:destroy)
    line_item.making_options.clear

    making_option = line_item.product.making_options.active.where(making_option_id: params[:product_making_option_id]).first
    line_item.making_options << LineItemMakingOption.build_option(making_option, line_item.currency)

    current_order.reload
    current_order.hydrate
    render json: current_order, serializer: OrderSerializer, status: :ok
  end

  def destroy
    line_item = current_order(true).line_items.find(params[:line_item_id])
    line_item&.destroy

    current_order.hydrate
    render json: current_order, serializer: OrderSerializer, status: :ok
  end

  def restore
    abandoned_cart = Bronto::CartRestorationService.get_abandoned_cart(params[:cart_id])

    if abandoned_cart.nil?
      render :json => {:success=>false}, status: 404
    end

    restore_cart(abandoned_cart['lineItems'].map { |item| item['other'] })

    cart = @user_cart.serialize

    unless cart.nil?
      render :json => {:success=>true, :cart=>cart, :abandoned_cart=>abandoned_cart}, status: 200
    else
      render :json => {:success=>false}, status: 400
    end
  end

  private

  def cart_product_service
    @cart_product_service ||= UserCart::CartProduct.new(
      order: current_order(true),
      line_item_id: params[:line_item_id]
    )
  end

  def restore_cart(line_item_ids)
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)

    line_item_ids.each do |line_item_id|
      li = Spree::LineItem.find(line_item)
      next if li.order.completed?
      
      if populator.populate(line_item: [line_item_id.to_i])
        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')

        current_order.reload
      end
      
    end
  end

end
