module Afterpay::SDK::Merchant
  class ItemType < Afterpay::SDK::Core::BaseDataType
    add_atribute :name,     required: true,  default: String.new
    add_atribute :sku,      required: false, default: String.new
    add_atribute :quantity, required: true,  default: Number.new
    add_atribute :price,    required: true,  default: MoneyType.new
  end
end
