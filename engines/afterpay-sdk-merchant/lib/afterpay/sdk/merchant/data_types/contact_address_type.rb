module Afterpay::SDK::Merchant
  class ContactAddressType < Afterpay::SDK::Core::BaseDataType
    add_atribute :name,         required: false, default: String.new
    add_atribute :line1,        required: true,  default: String.new
    add_atribute :line2,        required: false, default: String.new
    add_atribute :suburb,       required: true,  default: String.new
    add_atribute :state,        required: true,  default: String.new
    add_atribute :postcode,     required: true,  default: String.new
    add_atribute :country_code, required: true,  default: String.new, alias: 'countryCode'
    add_atribute :phone_number, required: true,  default: String.new, alias: 'phoneNumber'
  end
end
