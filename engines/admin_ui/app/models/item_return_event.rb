class ItemReturnEvent < ActiveRecord::Base
  include EventSourcedRecord::Event

  # Use the top attr accessible for attributes which are shared,
  # and use specific ones just above each event.

  attr_accessible :order_number,
                  :line_item_id,
                  :qty,
                  :requested_action,
                  :reason_category,
                  :reason_sub_category,
                  :request_notes,
                  :contact_email,
                  :product_name,
                  :product_style_number,
                  :product_colour,
                  :product_size,
                  :product_customisations,
                  :order_payment_method,
                  :order_paid_amount,
                  :order_payment_ref,
                  :order_paid_currency,
                  :acceptance_status,
                  :requested_at,
                  :customer_name

  serialize :data

  belongs_to :item_return, foreign_key: 'item_return_uuid', primary_key: 'uuid'

  event_type :creation do
    attributes :line_item_id
    validates  :line_item_id, presence: true
  end

  attr_accessible :request_id
  event_type :return_requested do
    attributes :order_number,
          :line_item_id,
          :qty,
          :requested_action,
          :reason_category,
          :reason_sub_category,
          :request_notes,
          :request_id,
          :contact_email,
          :product_name,
          :product_style_number,
          :product_colour,
          :product_size,
          :product_customisations,
          :order_payment_method,
          :order_paid_amount,
          :order_payment_ref,
          :order_paid_currency,
          :acceptance_status,
          :requested_at,
          :customer_name

  end

  attr_accessible :user, :received_on, :location

  event_type :receive_item do
    attributes :user, :received_on, :location

    validates :user,        presence: true
    validates :location,    presence: true
    validates :received_on, presence: true

    validate :location, inclusion: { in: ItemReturn::RECEIVE_LOCATIONS }
  end

  attr_accessible :user, :comment

  event_type :approve do
    attributes :user, :comment
  end

  LEGACY_DATA_IMPORT_ATTRIBUTES = [
    :row_number,
    :rj_ident,
    :column_b,
    :receive_state,
    :spree_order_number,
    :return_cancellation_credit,
    :name,
    :order_date,
    :order_month,
    :return_requested_on,
    :comments,
    :product,
    :size,
    :colour,
    :return_category,
    :return_sub_category,
    :return_office,
    :received,
    :in_inventory,
    :notes,
    :restocking,
    :returned_to_factory,
    :refund_status,
    :payment_method,
    :refund_method,
    :currency,
    :amount_paid,
    :spree_amount_paid,
    :refund_amount,
    :date_refunded,
    :email,
    :account_name,
    :account_number,
    :account_bsb,
    :account_swift,
    :customers_notes,
    :quantity,
    :deleted_row,
    # Calculated Attributes
    :refund_amount_in_cents,
    :refunded_at,
    :requested_at,
    :acceptance_status,
    :product_style_number,
    :product_customisations,
    :order_paid_currency,
    :order_paid_amount
  ]

  attr_accessible *LEGACY_DATA_IMPORT_ATTRIBUTES

  event_type :legacy_data_import do
    attributes *LEGACY_DATA_IMPORT_ATTRIBUTES
  end
end


