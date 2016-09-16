module Afterpay::SDK::Merchant
  class DiscountType < Afterpay::SDK::Core::BaseDataType
    add_atribute :displayName, required: true,  default: String.new
    add_atribute :money,       required: false, default: MoneyType.new
  end
end
