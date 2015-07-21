# Based on https://github.com/spree/spree/blob/1-3-stable/core/lib/spree/core/testing_support/factories/adjustment_factory.rb

FactoryGirl.define do
  factory :adjustment, :class => Spree::Adjustment do
    # adjustable { FactoryGirl.create(:order) }
    amount '100.0'
    label 'Shipping'
    # source { FactoryGirl.create(:shipment) }
    eligible true
  end
end
