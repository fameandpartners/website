module Afterpay::SDK::Merchant
  module DataType
    autoload :ConsumerType,       'afterpay/sdk/merchant/data_types/consumer_type'
    autoload :ContactAddressType, 'afterpay/sdk/merchant/data_types/contact_address_type'
    autoload :CourierType,        'afterpay/sdk/merchant/data_types/courier_type'
    autoload :DiscountType,       'afterpay/sdk/merchant/data_types/discount_type'
    autoload :ItemType,           'afterpay/sdk/merchant/data_types/item_type'
    autoload :MoneyType,          'afterpay/sdk/merchant/data_types/money_type'
    autoload :OrderDetailsType,   'afterpay/sdk/merchant/data_types/order_details_type'
    autoload :PaymentEventType,   'afterpay/sdk/merchant/data_types/payment_event_type'
    autoload :RefundType,         'afterpay/sdk/merchant/data_types/refund_type'
  end
end
