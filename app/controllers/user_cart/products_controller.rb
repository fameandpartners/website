class UserCart::ProductsController < UserCart::BaseController
  respond_to :json
  protect_from_forgery except: [:create, :destroy]
  # {"size_id"=>"34", "color_id"=>"89", "customizations_ids"=>"", "variant_id"=>"19565"}

  def order_is_valid_for_add_to_cart(order)
    state_str = order&.state
    order && (state_str.nil? || state_str == "cart" || state_str == "address" || (state_str == "payment" && order.payments.count == 0))
  end
  # 得到当前用户的可用于新添加衣服的订单，只查找处于cart和address状态的订单（特别要排除处于payment和complete的状态的订单，因为payment状态的order可能正在处于支付过程中，不能允许用户再次往里面添加衣服）
  def current_order_for_add_to_cart(create_order_if_necessary = false)
    if @current_order
      return @current_order if order_is_valid_for_add_to_cart @current_order
    end
    @current_order = nil
    if session[:order_id]
      current_order = Spree::Order.find_by_id_and_currency(session[:order_id], current_currency, :include => :adjustments)
      @current_order = current_order if order_is_valid_for_add_to_cart current_order
    end
    if create_order_if_necessary and @current_order.nil?
      @current_order = Spree::Order.new(:currency => current_currency)
      @current_order.user ||= try_spree_current_user
      @current_order.save!

      # make sure the user has permission to access the order (if they are a guest)
      if try_spree_current_user.nil?
        session[:access_token] = @current_order.token
      end
    end
    if @current_order
      unless @current_order.last_ip_address == ip_address
        @current_order.last_ip_address = ip_address
        @current_order.save!
      end
      session[:order_id] = @current_order.id
    end
    @current_order
  end

  def create
    cart_populator = UserCart::Populator.new(
      order: current_order_for_add_to_cart(true),
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
      if spree_user_signed_in? && current_order_for_add_to_cart.user.nil?
        self.extend(Spree::Core::ControllerHelpers::Order)
        associate_user
      end

      current_order_for_add_to_cart.hydrate

      respond_with(current_order_for_add_to_cart) do |format|
        format.json   {
          render json: current_order_for_add_to_cart, serializer: OrderSerializer, status: :ok
        }
      end
    else # not success
      NewRelic::Agent.notify('AddToCartFailed',
                             message: result.message,
                             order_number: current_order_for_add_to_cart.number,
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
    line_item = current_order_for_add_to_cart(true).line_items.find(params[:line_item_id])
    line_item.making_options.each(&:destroy)
    line_item.making_options.clear

    making_option = line_item.product.making_options.active.where(making_option_id: params[:product_making_option_id]).first
    line_item.making_options << LineItemMakingOption.build_option(making_option, line_item.currency)

    current_order_for_add_to_cart.reload
    current_order_for_add_to_cart.hydrate
    render json: current_order_for_add_to_cart, serializer: OrderSerializer, status: :ok
  end

  def destroy
    line_item = current_order_for_add_to_cart(true).line_items.find(params[:line_item_id])
    line_item&.destroy

    current_order_for_add_to_cart.hydrate
    render json: current_order_for_add_to_cart, serializer: OrderSerializer, status: :ok
  end

  def restore
    abandoned_cart = Bronto::CartRestorationService.get_abandoned_cart(params[:cart_id])

    if abandoned_cart.nil?
      render :json => {:success=>false}, status: 404
    end

    restore_cart(abandoned_cart['lineItems'].map { |item| item['other'] })

    cart = current_order_for_add_to_cart.serialize

    unless cart.nil?
      render :json => {:success=>true, :cart=>cart, :abandoned_cart=>abandoned_cart}, status: 200
    else
      render :json => {:success=>false}, status: 400
    end
  end

  private

  def cart_product_service
    @cart_product_service ||= UserCart::CartProduct.new(
      order: current_order_for_add_to_cart(true),
      line_item_id: params[:line_item_id]
    )
  end

  def restore_cart(line_item_ids)
    populator = Spree::OrderPopulator.new(current_order_for_add_to_cart(true), current_currency)

    line_item_ids.each do |line_item_id|
      li = Spree::LineItem.find(line_item_id)
      next if li.order.completed?

      if populator.populate(line_item: [line_item_id.to_i])
        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')

        current_order_for_add_to_cart.reload
      end

    end
  end

end
