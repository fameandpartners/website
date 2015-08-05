require 'spree/core/testing_support/factories/address_factory'

FactoryGirl.modify do
  factory :address, :class => Spree::Address do
    firstname          { Faker::Name.first_name           }
    lastname           { Faker::Name.last_name            }
    company            { Faker::Company.name              }
    address1           { Faker::Address.street_address    }
    address2           { Faker::Address.secondary_address }
    city               { Faker::AddressAU.city            }
    zipcode            { Faker::AddressAU.postcode        }
    phone              { Faker::PhoneNumber.phone_number  }
    alternative_phone  { Faker::PhoneNumber.phone_number  }
  end
end
