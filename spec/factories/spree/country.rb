require 'spree/core/testing_support/factories/country_factory'

FactoryGirl.modify do
  factory :country, :class => Spree::Country do
    iso_name 'UNITED STATES'
    name     'United States of Foo'
    iso      'US'
    iso3     'USA'
    numcode  840

    trait :australia do
      iso_name 'AUSTRALIA'
      name     'Australia'
      iso      'AU'
      iso3     'AUS'
      numcode  061
    end

    # Trait is redundant with default factory on purpose, in sake of explicitness
    trait :united_states do
      iso_name 'UNITED STATES'
      name     'United States of Foo'
      iso      'US'
      iso3     'USA'
      numcode  840
    end
  end
end
