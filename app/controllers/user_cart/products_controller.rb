class UserCart::ProductsController < UserCart::BaseController
  respond_to :json
  protect_from_forgery except: [:create, :destroy]
  # {"size_id"=>"34", "color_id"=>"89", "customizations_ids"=>"", "variant_id"=>"19565"}


  def create
    ensure_size_id_is_set( params )
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

      reapply_delivery_promo

      @user_cart = user_cart_resource.read

      data = add_analytics_labels(@user_cart.serialize)

      respond_with(@user_cart) do |format|
        format.json   {
          render json: data, status: :ok
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
    cart_product_service.create_making_option(params[:product_making_option_id])
    render json: user_cart_resource.read.serialize, status: :ok
  end

  def destroy
    cart_product_service.destroy
    reapply_delivery_promo
    render json: user_cart_resource.read.serialize, status: :ok
  end

  def destroy_customization
    cart_product_service.destroy_customization(params[:customization_id])
    reapply_delivery_promo
    render json: user_cart_resource.read.serialize, status: :ok
  end

  def destroy_making_option
    cart_product_service.destroy_making_option(params[:making_option_id])
    reapply_delivery_promo
    render json: user_cart_resource.read.serialize, status: :ok
  end

  def move_to_cart
    @item = Spree::LineItem.find_by_id(params[:id])

    if @item.stock
      populator = Spree::OrderPopulator.new(current_order(true), current_currency)

      if populator.populate(line_item: [params[:id].to_i])
        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')

        current_order.reload
      end
      @user_cart = user_cart_resource.read
      data = add_analytics_labels(@user_cart.serialize)


      respond_with(@user_cart) do |format|
        format.json   {
          render json: data, status: :ok
        }
      end
    else
      NewRelic::Agent.notify('AddToCartFailed',
                             message: 'Out of Stock',
                             order_number: current_order.number,
                             site_version: current_site_version.code)
      respond_with({}) do |format|
        format.json   {
          render json: { error: true, message: 'Out of Stock' }, status: 422
        }
      end
    end
  end

  def restore
    abandoned_cart = Bronto::CartRestorationService.get_abandoned_cart(params[:cart_id])

    restore_cart(abandoned_cart['lineItems'].map { |item| item['other'] })

    cart = @user_cart.serialize

    unless cart.nil?
      render :json => {:success=>true, :cart=>cart, :abandoned_cart=>abandoned_cart}, status: 200
    else
      render :json => {:success=>false}, status: 400
    end
  end

  private

  def add_analytics_labels(data)
    data = @user_cart.serialize

    data[:products].each do |product|
      product[:analytics_label] = analytics_label(:user_cart_product, product)
    end
    data
  end

  def cart_product_service
    @cart_product_service ||= UserCart::CartProduct.new(
      order: current_order(true),
      line_item_id: params[:line_item_id]
    )
  end

  def reapply_delivery_promo
    if current_promotion.present? && current_promotion.code.include?('DELIVERYDISC')
      promotion_service = UserCart::PromotionsService.new(
        order: current_order,
        code:  'DELIVERYDISC'
      )
      promotion_service.reapply
    end
  end

  def ensure_size_id_is_set( params )
    if( params[:size_id].nil? && !params[:size].nil? )
      params[:size_id]=Spree::OptionValue.where( 'option_type_id=? and name=?', Spree::OptionType.where( 'name = ?', "dress-size" ).first.id, params[:size] ).first.id
    elsif (params[:variant_id].to_s.starts_with?('SW'))
      #need a size set for fabric swatches
      params[:size_id] = Spree::OptionValue.find_by_name('US0/AU4').id
    end
  end

  def restore_cart(line_item_ids)
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)

    line_item_ids.each do |line_item_id|
      if populator.populate(line_item: [line_item_id.to_i])
        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')

        current_order.reload
      end
      
    end
    
    @user_cart = user_cart_resource.read
    data = add_analytics_labels(@user_cart.serialize)

  end

end
