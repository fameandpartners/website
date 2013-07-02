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

  # order_id
  # variant_id
  def destroy
    line_items = current_order.line_items.where(variant_id: params[:variant_id])
    line_items.destroy_all

    current_order.reload

    render json: { order: CartSerializer.new(current_order).to_json }
  end
end
