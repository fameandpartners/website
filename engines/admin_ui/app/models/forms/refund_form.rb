require 'reform'

module Forms
  class RefundForm < ::Reform::Form
    property :user
    property :refund_method
    property :refund_amount
    property :comment
    property :event_type, writeable: false

    validates :user, presence: true
    validates :refund_method, presence: true
    validates :refund_amount, presence: true
  end
end
