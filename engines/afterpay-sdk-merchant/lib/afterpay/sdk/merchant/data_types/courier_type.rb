module Afterpay::SDK::Merchant
  class ConsumerType < Afterpay::SDK::Core::BaseDataType
    add_atribute :shipped_at, required: false, default: String.new, alias: 'shippedAt'
    add_atribute :name,       required: false, default: String.new
    add_atribute :tracking,   required: false, default: String.new
    add_atribute :priority,   required: false, default: String.new
  end
end
