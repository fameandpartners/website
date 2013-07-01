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

  # order_id
  # variant_id
  # quantity
  def update
    raise 'update'
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
