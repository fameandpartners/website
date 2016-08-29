require 'datagrid'

class RefundGrid
  include Datagrid

  filter(:order_number)
  filter(:return_status, :enum, select: ['Received', 'Not Received']) do |value|
    (value == 'Received') ? where(acceptance_status: 'received') : where("acceptance_status != 'received'")
  end
  filter(:refund_amount, :integer, range: true)
  filter(:return_status, :enum, select: ['Paid', 'Not Paid']) do |value|
    (value == 'Paid') ? where(refund_status: 'Complete') : where("refund_status != 'Complete'")
  end

  scope do
    ItemReturn.includes(line_item: { order: :shipments })
  end

  column :order_number
  column(:line_item_sku) do |item_return|
    next unless item_return.line_item.present?
    CustomItemSku.new(item_return.line_item).call
  end
  column(:date_purchased) do |item_return|
    next unless item_return.line_item.present?
    item_return.line_item.order.completed_at.try(:strftime, '%Y-%m-%d')
  end
  column(:date_goods_shipped) do |item_return|
    next unless item_return.line_item.present?
    item_return.line_item.order.shipments.first.try(:shipped_at).try(:strftime, '%Y-%m-%d')
  end
  column(:return_status) do |item_return|
    item_return.acceptance_status == 'received' ? 'Received' : 'Not Received'
  end
  column(:refund_amount) do |item_return|
    Money.new(item_return.refund_amount, 'USD').format
  end
  column :refund_status do |item_return|
    item_return.refund_status == 'Complete' ? 'Paid' : 'Not Paid'
  end
end
