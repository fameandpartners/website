module Afterpay::SDK::Merchant
  class OrderDetailsType < AfterPay::SDK::Core::BaseDataType
    add_atribute :consumer,        required: true,  default: ConsumerType.new
    add_atribute :billing,         required: false, default: ContactAddressType.new
    add_atribute :shipping,        required: false, default: ContactAddressType.new
    add_atribute :courier,         required: false, default: CourierType.new
    add_atribute :items,           required: false, default: [ ItemType.new ]
    add_atribute :discount,        required: false, default: [ DiscountType.new ]
    add_atribute :tax_amount,      required: false, default: MoneyType.new, alias: 'taxAmount'
    add_atribute :shipping_amount, required: false, default: MoneyType.new, alias: 'shippingAmount'
  end
end
