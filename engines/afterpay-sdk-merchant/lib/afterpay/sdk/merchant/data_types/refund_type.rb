module Afterpay::SDK::Merchant
  class PaymentEventType < Afterpay::SDK::Core::BaseDataType
    add_atribute :id,                 required: true, default: String.new
    add_atribute :refunded_at,        required: true, default: String.new, alias: 'refundedAt'
    add_atribute :merchant_reference, required: true, default: String.new, alias: 'merchantReference'
    add_atribute :amount,             required: true, default: MoneyType.new
  end
end
