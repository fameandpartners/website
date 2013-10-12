class LineItemsController < Spree::StoreController
  respond_to :json
  respond_to :js, only: [:create]

  def create
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)

    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1

    @product = Spree::Variant.where(id: params[:variant_id]).first.try(:product)

    if params[:line_item_personalization].present?
      @personalization = LineItemPersonalization.new(params[:line_item_personalization])
      @personalization.product = @product
    end

    if (@personalization.blank? || @personalization.valid?) && populator.populate(variants: { params[:variant_id] => quantity })
      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      current_order.reload
    end

    Activity.log_product_added_to_cart(@product, temporary_user_key, try_spree_current_user, current_order) rescue nil

    @line_item = current_order.line_items.find_by_variant_id(params[:variant_id])

    if @personalization.present? && @line_item.present?
      @personalization.line_item = @line_item
      @personalization.save
      current_order.update!
      current_order.reload
    end

    respond_with @line_item do |format|
      format.json do
        render json: {
          order: CartSerializer.new(current_order).to_json,
          analytics_label: analytics_label(:product, @product)
        }
      end
      format.js do
        render :create
      end
    end
  end

  # edit item in cart
  def edit
    raise "can't find without an id" if params[:id].blank?

    line_item = current_order.line_items.find(params[:id])
    @product_variants = Products::VariantsReceiver.new(line_item.variant.product_id).available_options

    render json: {
      variants: @product_variants,
      line_item: LineItemSerializer.new(line_item)
    }
  end

  # id: line-item-imd
  # params[:variant_id]
  # params[:quantity]
  def update
    line_item = current_order.line_items.find(params[:id])

    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1
    if line_item.update_attributes(variant_id: params[:variant_id], quantity: quantity)
      current_order.reload
    end

    render json: { order: CartSerializer.new(current_order).to_json }
  end

  # params[:variant_id]
  # params[:quantity]
  def move_to_wishlist
    user = try_spree_current_user
    variant = Spree::Variant.find(params[:variant_id])
    line_item = current_order.line_items.where(variant_id: variant.id).first

    status = :bad_request
    if line_item
      wishlist_item = user.wishlist_items.where(spree_product_id: variant.product_id).first
      wishlist_item ||= user.wishlist_items.create(
        spree_variant_id: variant.id,
        spree_product_id: variant.product_id,
        quantity: line_item.quantity
      )
      if wishlist_item.persisted?
        line_item.destroy
        status = :ok
      end
    end
    current_order.reload

    json_result = {
      order: CartSerializer.new(current_order).to_json,
      analytics_label: analytics_label(:product, variant.product)
    }

    render json: json_result, status: status
  end

  # order_id
  # variant_id
  def destroy
    line_item = current_order.line_items.where(variant_id: params[:variant_id]).first

    if line_item.destroy
      current_order.reload
      render json: { order: CartSerializer.new(current_order).to_json}, status: :ok
    else
      render json: { order: CartSerializer.new(current_order).to_json}, status: :bad_request
    end
  end
end
