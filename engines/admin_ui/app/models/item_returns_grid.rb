require 'datagrid'

class ItemReturnsGrid
  include Datagrid

  scope do
    ItemReturn.includes(:line_item)
  end

  filter(:acceptance_status, :enum,
         checkboxes: true,
         allow_blank: true,
         select: ItemReturn::STATES.map { |x| [x.to_s.humanize, x] },
         default: -> { ItemReturn::STATES - [:refunded, :credit_note_issued] })
  filter(:refund_status, :enum, select: -> { ItemReturn.pluck(:refund_status).uniq })
  filter(:requested_action, :enum, select: -> { ItemReturn.pluck(:requested_action).uniq })
  filter(:order_payment_method, :enum, select: -> { ItemReturn.pluck(:order_payment_method).uniq })
  filter(:order_number, :string) {|value| where("order_number ilike ?", "%#{value}%")}
  filter(:contact_email, :string) {|value| where("contact_email ilike ?", "%#{value}%")}
  filter(:product_style_number, :string, header: 'Style')
  filter(:product_name, :string) {|value| where("product_name ilike ?", "%#{value}%")}
  filter(:customer_name, :string) {|value| where("customer_name ilike ?", "%#{value}%")}

  filter(:product_customisations, :xboolean)
  filter(:custom1, :dynamic)
  filter(:custom2, :dynamic)

  column :actions, :html => true do |item_return|
     link_to "manage", item_return_path(item_return), class: 'btn btn-xs btn-info'
   end

  column :requested_action, header: 'Request', html: true do |item_return|
    content_tag(:i, item_return.requested_action.to_s.upcase.first, class: action_icon_class(item_return.requested_action))
  end

  column :order_number,           header: 'Order Number'  
  column :acceptance_status,      header: 'Status'
  column :customer_name
  column :order_number,           header: 'Order', order: 'item_returns.order_number', html: true do |item_return|
    link_to item_return.order_number, spree.admin_order_path(id: item_return.order_number)
  end
  column :order_number,           header: 'Order', html: false
  column :product_style_number,   header: 'Style'
  column :product_name,           header: 'Product'
  column :product_colour,         header: 'Colour'
  column :product_size,           header: 'Size'
  column :height,                 header: 'Height' do |item_return|
    item_return.line_item.try(:personalization).try(:height)
  end
  column :product_customisations, header: 'Custom?' do |item_return|
    format(item_return.product_customisations) do |is_custom|
      content_tag(:i, '', class: 'fa fa-scissors  fa-lg text-warning' ) if is_custom
    end
  end
  column :customisation_type,     header: 'Customisation type' do |item_return|
    item_return.line_item.options_text if item_return.product_customisations
  end
  column :requested_at do |ir|
    ir.requested_at.try :to_date
  end

  column :reason_category,        header: 'Reason Category'
  column :reason_sub_category,    header: 'Reason sub-Category'
  column :country,                header: 'Country' do |item_return|
    item_return.line_item.try(:order).try(:shipping_address).try(:country).try(:name)
  end
end
