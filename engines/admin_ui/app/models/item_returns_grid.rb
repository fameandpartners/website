require 'datagrid'

class ItemReturnsGrid
  include Datagrid

  scope do
    ItemReturn
  end

  column :actions, :html => true do |item_return|
     link_to "manage", item_return_path(item_return)
   end


  column :acceptance_status,      header: 'Status'
  column :customer_name
  column :order_number,           header: 'Order', order: 'item_returns.order_number'
  column :product_style_number,   header: 'Style'
  column :product_name,           header: 'Product'
  column :product_colour,         header: 'Colour'
  column :product_size,           header: 'Size'
  column :product_customisations, header: 'Custom?' do |item_return|
    format(item_return.product_customisations) do |is_custom|
      content_tag(:i, '', class: 'fa fa-scissors  fa-lg text-warning' ) if is_custom
    end
  end


  # column :item_id
  column :requested_at do |ir|
    ir.requested_at.try :to_date
  end
  column :requested_action,       header: 'Request' do |item_return|
    format(item_return.requested_action) do |ra|
      ra.to_s.first.upcase
    end
  end
  column :reason_category
  # column :reason_sub_category
  column :contact_email


  # column :order_number
  # column :item_id
# column :qty
  # column :requested_action
  # column :requested_at
  # column :reason_category
  # column :reason_sub_category
  column :request_notes
  # column :customer_name
  # column :contact_email

  column :comments
  # column :product_name
  # column :product_style_number
  # column :product_colour
  # column :product_size
  # column :product_customisations
  column :received_on
  column :received_location
  column :order_payment_method, header: 'Paid'
  column :order_paid_amount,    header: 'Amount' do |item_return|
    #
    # Money.new(
    #   item_return.order_paid_amount,
    #   item_return.order_paid_currency
    # ).format
  end
  column :order_paid_currency, header: 'Currency'
  # column :order_payment_ref
  column :refund_status
  column :refund_ref
  column :refund_method
  column :refund_amount
  column :refunded_at







end
