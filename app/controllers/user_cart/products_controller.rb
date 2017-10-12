class UserCart::ProductsController < UserCart::BaseController
  respond_to :json

  # {"size_id"=>"34", "color_id"=>"89", "customizations_ids"=>"", "variant_id"=>"19565"}

  
  def create
    ensure_size_id_is_set( params )
    ensure_height_is_set( params )
    
    cart_populator = UserCart::Populator.new(
      order: current_order(true),
      site_version: current_site_version,
      currency: current_currency,
      product: {
        variant_id: params[:variant_id],
        size_id: params[:size_id],
        color_id: params[:color_id],
        customizations_ids: params[:customizations_ids],
        making_options_ids: params[:making_options_ids],
        height:             params[:height],
        height_value:       params[:height_value],
        height_unit:        params[:height_unit],
        quantity: 1
      }
    )
    result = cart_populator.populate

    if result.success
      if spree_user_signed_in? && current_order.user.nil?
        self.extend(Spree::Core::ControllerHelpers::Order)
        associate_user
      end

      if current_promotion.present?
        promotion_service = UserCart::PromotionsService.new(
          order: current_order,
          code:  current_promotion.code
        )

        if promotion_service.apply
          fire_event('spree.order.contents_changed')
          fire_event('spree.checkout.coupon_code_added')
        end
      end

      @user_cart = user_cart_resource.read

      data = add_analytics_labels(@user_cart.serialize)

      flash[:variant_id_added_to_cart] = params[:dress_variant_id].presence

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
    render json: user_cart_resource.read.serialize, status: :ok
  end

  def destroy_customization
    cart_product_service.destroy_customization(params[:customization_id])
    render json: user_cart_resource.read.serialize, status: :ok
  end

  def destroy_making_option
    cart_product_service.destroy_making_option(params[:making_option_id])
    render json: user_cart_resource.read.serialize, status: :ok
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

  def ensure_size_id_is_set( params )
    if( params[:size_id].nil? && !params[:size].nil? )
      params[:size_id]=Spree::OptionValue.where( 'option_type_id=? and name=?', Spree::OptionType.where( 'name = ?', "dress-size" ).first.id, params[:size] ).first.id
    end
  end

  def ensure_height_is_set( params )
    if( params[:height].nil? && params[:height_value] && params[:variant_id])
      variant = Spree::Variant.find( params[:variant_id] )
      product_height_range_group = ProductHeightRangeGroup.find_both_for_variant_or_use_default( variant ).find { |phrg| phrg.unit == params[:height_unit] }
      params[:height] = product_height_range_group.map_height_to_name( params[:height_value] )
    end
    
  end
  
end
