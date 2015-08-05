require 'spree/core/testing_support/factories/country_factory'

FactoryGirl.modify do
  factory :country, :class => Spree::Country do
    iso_name 'UNITED STATES'
    name     'United States of Foo'
    iso      'US'
    iso3     'USA'
    numcode  840
  end
end
