require 'datagrid'

class ItemReturnsGrid
  include Datagrid

  scope do
    ItemReturn
  end

  SCOPES = {
    requests: ItemReturn,
    processed: ItemReturn.where(refund_status: 'Completed'),
    exceptions: ItemReturn
  }

  FILTERS = {
    requests: [{
      name: :acceptance_status,
      type: :enum, 
      options: {
        before: true,
        checkboxes: true,
        allow_blank: true,
        select: ItemReturn::STATES.map { |x| [x.to_s.humanize, x] },
        default: -> { ItemReturn::STATES - [:refunded, :credit_note_issued] }
      }
    }, {
      name: :refund_status, type: :enum, options: { after: :acceptance_status, select: -> { ItemReturn.pluck(:refund_status).uniq } }
    }, {
      name: :requested_action, type: :enum, options: { after: :refund_status, select: -> { ItemReturn.pluck(:requested_action).uniq } }
    }],

    processed: [{
      name: :requested_action, type: :enum, options: { select: -> { ItemReturn.pluck(:requested_action).uniq } }
    }],

    exceptions: [{
      name: :exception_reason,
      type: :enum, 
      options: {
        before: true,
        checkboxes: true,
        allow_blank: true,
        select: ItemReturn::STATES.map { |x| [x.to_s.humanize, x] },
        default: -> { ItemReturn::STATES - [:refunded, :credit_note_issued] }
      }
    }, {
      name: :dismissed_items, type: :enum, options: { after: :exception_reason, checkboxes: true, allow_blank: true, select: -> { [:yes, :no] } }
    }]
  }

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
  column :product_style_number,   header: 'Style'
  column :product_name,           header: 'Product'
  column :product_colour,         header: 'Colour'
  column :product_size,           header: 'Size'
  column :product_customisations, header: 'Custom?' do |item_return|
    format(item_return.product_customisations) do |is_custom|
      content_tag(:i, '', class: 'fa fa-scissors  fa-lg text-warning' ) if is_custom
    end
  end

  column :requested_at do |ir|
    ir.requested_at.try :to_date
  end

  def self.extend_with_custom_filters(type:)
    custom_filters = FILTERS.fetch(type)
    excess_filters = FILTERS.values.flatten.map { |f| f[:name] }.uniq

    filters.delete_if { |f| excess_filters.include?(f.name) }

    custom_filters.each do |f|
      filter(f[:name], f[:type], (f[:options] || {}), &f[:block])
    end
  end

  def self.set_scope(type:)
    scope { SCOPES.fetch(type) }
  end
end
