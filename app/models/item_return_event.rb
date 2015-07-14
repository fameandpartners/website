class ItemReturnEvent < ActiveRecord::Base
  include EventSourcedRecord::Event


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

  attr_accessible :user, :received_on, :location


  serialize :data

  belongs_to :item_return,
    foreign_key: 'item_return_uuid', primary_key: 'uuid'

  event_type :creation do
    attributes :line_item_id
    validates  :line_item_id, presence: true
  end

  event_type :return_requested do
    attributes :order_number,
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

  end

  event_type :receive_item do
    attributes :user, :received_on, :location

    validates :user,        presence: true
    validates :location,    presence: true
    validates :received_on, presence: true

    validate :location, inclusion: { in:  ['AU', 'US'] }
  end

end


