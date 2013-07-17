class LineItemsController < Spree::StoreController
  respond_to :json

  def create
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)

    if populator.populate(variants: { params[:variant_id] => params[:quantity] })
      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      current_order.reload
    end

    render json: { order: CartSerializer.new(current_order).to_json }
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

    if line_item.update_attributes(variant_id: params[:variant_id], quantity: params[:quantity])
      current_order.reload
    end

    render json: { order: CartSerializer.new(current_order).to_json }
  end

  # params[:variant_id]
  # params[:quantity]
  def move_to_wishlist
    user = try_spree_current_user
    line_item = current_order.line_items.where(variant_id: params[:variant_id]).first

    status = :bad_request
    if line_item
      wishlist_item = user.wishlist_items.where(spree_variant_id: line_item.variant_id).first_or_create
      if wishlist_item.persisted?
        line_item.destroy
        status = :ok
      end
    end
    current_order.reload

    render json: { order: CartSerializer.new(current_order).to_json }, status: status
  end

  # order_id
  # variant_id
  def destroy
    line_items = current_order.line_items.where(variant_id: params[:variant_id])
    line_items.destroy_all

    current_order.reload

    status = line_items.length > 0 ? :ok : :bad_request 
    render json: { order: CartSerializer.new(current_order).to_json}, status: status
  end
end
