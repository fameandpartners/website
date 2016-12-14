require 'spree/core/testing_support/factories/payment_method_factory'

FactoryGirl.define do
  factory :paypal_express, class: Spree::Gateway::PayPalExpress do
    name 'Paypal Express'
    environment 'test'

    trait :active do
      active true
    end
  end
end
