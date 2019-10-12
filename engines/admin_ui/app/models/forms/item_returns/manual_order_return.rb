require 'reform'

module Forms
  module ItemReturns
    class ManualOrderReturn < ::Reform::Form
      include ::Reform::Form::ActiveModel::ModelReflections
      property :manual_order_data
      property :order_number,         validates: { presence: true}
      property :line_item_number,     validates: { presence: true}
      property :item_price,           type: Numeric
      property :item_price_adjusted,  type: Numeric, validates: { presence: true}
      property :qty,                  type: Numeric
      property :requested_action,     validates: {presence: true, inclusion: {in: ReturnRequestItem::ACTIONS}}
      property :reason_category,      validates: {presence: true, inclusion: {in: ReturnRequestItem::REASON_CATEGORIES}}
      property :reason_sub_category,  validates: {presence: true, inclusion: {in: ReturnRequestItem::REASON_SUB_CATEGORIES}}
      property :request_notes
      property :contact_email,        validates: {presence: true}
      property :product_name,         validates: {presence: true}
      property :product_style_number, validates: {presence: true}
      property :product_colour
      property :product_size
      property :product_customisations
      property :order_payment_method, validates: {presence: true, inclusion: {in: ->(_) {ItemReturn.pluck(:order_payment_method).uniq} }}
      property :order_paid_amount,    type: Numeric, validates: {presence: true}
      property :order_payment_date
      property :order_payment_ref
      property :order_paid_currency,  validates: {presence: true, inclusion: {in: ->(_) {SiteVersion.pluck(:currency)} }}
      property :requested_at,         validates: {presence: true}
      property :customer_name,        validates: {presence: true}
      property :comment

      # Set by controller
      property :user,                 validates: {presence: true}

      # validates :order_number,  format: {with: /\A[^Rr]/, message: 'This looks like a regular Spree Order, this form is for Manual orders only.'}
      validates :order_number,  format: {with: /[A-Z][0-9]*/, message: 'This looks like a regular Spree Order, this form is for Manual orders only.'}

      def qty
        super || 1
      end

      def requested_at
        super || Date.today
      end

      def requested_action
        super || :return
      end
      def comment
        super || 'Manual Order'
      end

      def reason_category
        super || ReturnRequestItem::REASON_CATEGORY_MAP.select {|_k,v| v.include?(reason_sub_category) }.keys.first
      end
    end
  end
end
