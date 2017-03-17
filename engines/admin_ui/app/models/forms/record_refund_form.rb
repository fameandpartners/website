require 'reform'

module Forms
  class RecordRefundForm < ::Reform::Form
    property :user
    property :refund_method
    property :refund_amount
    property :refund_reference
    property :refunded_at
    property :comment
    property :event_type, writeable: false

    def refunded_at
      super || Date.today
    end

    validates :user, presence: true
    validates :refund_method, presence: true
    validates :refund_amount, presence: true, numericality: true
    validates :refunded_at, presence: true
  end
end
