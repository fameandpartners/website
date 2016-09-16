module Afterpay::SDK::Merchant
  class PaymentEventType < Afterpay::SDK::Core::BaseDataType
    add_atribute :created_at, required: true, default: String.new, alias: 'created'
    add_atribute :id,         required: true, default: String.new
    add_atribute :type,       required: true, default: String.new
  end
end
