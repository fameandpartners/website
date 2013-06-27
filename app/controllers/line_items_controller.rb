class LineItemsController < Spree::StoreController
  respond_to :json

  def create
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)

    if populator.populate(variants: { params[:variant_id] => params[:quantity] })
      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      current_order.reload
    end

    cart_html = render_to_string(
      partial: 'layouts/shopping_bag_content',
      locals: { current_order: current_order }
    )

    render json: {
      cart_html: cart_html,
      order: current_order.to_json
    }
  end

  # order_id
  # variant_id
  # quantity
  def update
  end

  # order_id
  # variant_id
  def destroy
    line_items = current_order.line_items.where(variant_id: params[:variant_id])
    line_items.destroy_all

    current_order.reload

    response = {}
    cart_html = render_to_string(
      partial: 'layouts/shopping_bag_content',
      locals: { current_order: current_order }
    )
    render json: {
      cart_html: cart_html,
      order: current_order.to_json
    }
  end
end
