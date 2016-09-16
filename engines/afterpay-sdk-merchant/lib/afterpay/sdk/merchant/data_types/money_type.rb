module Afterpay::SDK::Merchant
  class MoneyType < Afterpay::SDK::Core::BaseDataType
    add_atribute :amount,   required: true, default: String.new
    add_atribute :currency, required: true, default: String.new
  end
end
