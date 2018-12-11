require 'datagrid'

class ManualOrdersGrid
  include Datagrid

  scope do
    Spree::LineItem.joins(:order)
      .where("spree_orders.completed_at is NOT NULL and (spree_orders.number ILIKE 'M%' or spree_orders.number ILIKE 'E%' or spree_orders.number ILIKE 'D%')")
      .includes(product: [:master])
      .order('spree_orders.completed_at DESC')
  end

  decorate { |line_item| Orders::LineItemPresenter.new(line_item, Orders::OrderPresenter.new(line_item.order)) }

  filter :order_number do |value|
    where(Spree::Order.arel_table[:number].matches("%#{value}%"))
  end

  filter(:order_type, :enum,
         select: -> { { 'Manual' => 'M', 'Exchange' => 'E', 'Dropship' => 'D' } },
         :include_blank => true) do |value|
    where(Spree::Order.arel_table[:number].matches("#{value}%"))
  end

  column(:order_date, header: 'Order date', order: 'spree_orders.completed_at') do |model|
    model.order.completed_at.strftime("%m/%d/%y")
  end
  column(:delivery_due, header: 'Delivery due') do |model|
    model.projected_delivery_date&.strftime("%m/%d/%y")
  end
  column(:order_number, header: 'Order number', order: 'spree_orders.number', :html => true) do |model|
    link_to model.order.number, spree.admin_order_path(id: model.order.number)
  end
  column(:id, header: 'Line ID', order: 'spree_line_items.id') {|model| model.id}
  column(:style, header: 'Style') {|model| model.style_number}
  column(:style_name, header: 'Style name') {|model| model.style_name}
  column(:sku, header: 'SKU') {|model| model.sku}
  column(:size, header: 'Size') {|model| model.size}
  column(:height, header: 'Height') {|model| model.height}
  column(:color, header: 'Color') {|model| model.colour_name}
  column(:customisations, header: 'Customisations') {|model| model.customization_text}
  column(:factory, header: 'Factory') {|model| model.factory.name}
  column(:return_or_exchange, header: 'Return or Exchange', html: true) do |model|
    if !model.return_item
      link_to 'Return or Exchange', main_app.new_user_returns_path(order_number: model.order.number, email: model.order.email)
    else
      link_to 'Return Requested', main_app.return_detail_path(order_number: model.order.number)
    end
  end

end
