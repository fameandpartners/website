module Afterpay::SDK::Merchant
  class ConsumerType < Afterpay::SDK::Core::BaseDataType
    add_atribute :phone_number, required: false, default: String.new, alias: 'phoneNumber'
    add_atribute :given_names,  required: true,  default: String.new, alias: 'givenNames'
    add_atribute :surname,      required: true,  default: String.new
    add_atribute :email,        required: true,  default: String.new
  end
end
