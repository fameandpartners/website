require 'datagrid'

class ManualOrdersGrid
  include Datagrid

  scope do
    Spree::LineItem.joins(:order).where("spree_orders.completed_at is NOT NULL and
      (spree_orders.number ILIKE 'M%' or spree_orders.number ILIKE 'E%')").includes(:order)
  end

  filter :order_number do |value|
    where(Spree::Order.arel_table[:number].matches("%#{value}%"))
  end

  # TODO: replace decorate class def with gem's def after datagrid gem update to 1.4.4 version
  # decorate { |line_item| Orders::LineItemPresenter.new(line_item, Orders::OrderPresenter.new(line_item.order)) }

  column(:order_id, header: 'Order ID', order: 'spree_orders.id') {|model| model.order.id}
  column(:order_date, header: 'Order date', order: 'spree_orders.completed_at') do |model|
    model.order.completed_at.strftime("%m/%d/%y")
  end
  column(:delivery_due, header: 'Delivery due') do |model|
    ManualOrdersGrid.decorate(model).projected_delivery_date.strftime("%m/%d/%y")
  end
  column(:order_number, header: 'Order number', order: 'spree_orders.number', :html => true) do |model|
    link_to model.order.number, spree.admin_order_path(id: model.order.number)
  end
  column(:id, header: 'Line ID', order: 'spree_line_items.id') {|model| model.id}
  column(:style, header: 'Style') {|model| ManualOrdersGrid.decorate(model).style_number}
  column(:style_name, header: 'Style name') {|model| ManualOrdersGrid.decorate(model).style_name}
  column(:sku, header: 'SKU') {|model| ManualOrdersGrid.decorate(model).sku}
  column(:size, header: 'Size') {|model| ManualOrdersGrid.decorate(model).size}
  column(:height, header: 'Height') {|model| ManualOrdersGrid.decorate(model).height}
  column(:color, header: 'Color') {|model| ManualOrdersGrid.decorate(model).colour_name}
  column(:customisations, header: 'Customisations') {|model| ManualOrdersGrid.decorate(model).customisation_text}
  column(:factory, header: 'Factory') {|model| ManualOrdersGrid.decorate(model).factory.name}

  private

  def self.decorate(line_item)
    Orders::LineItemPresenter.new(line_item, Orders::OrderPresenter.new(line_item.order))
  end

end
