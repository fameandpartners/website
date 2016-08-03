require 'spree/core/testing_support/factories/shipment_factory'

FactoryGirl.define do
  factory :simple_shipment, :class => Spree::Shipment do
    order { FactoryGirl.create(:spree_order) }
    shipping_method { FactoryGirl.create(:simple_shipping_method) }
    tracking 'U10000'
    number '100'
    cost 100.00
    address { FactoryGirl.create(:address) }
    state 'pending'
  end
end
