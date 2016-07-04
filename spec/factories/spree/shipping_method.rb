require 'spree/core/testing_support/factories/shipping_method_factory'

FactoryGirl.define do
  factory :simple_shipping_method, :class => Spree::ShippingMethod do
    zone { |a| Spree::Zone.find_by_name('GlobalZone') || a.association(:global_zone) }
    name 'UPS Ground'
    calculator { FactoryGirl.build(:simple_calculator) }
  end
end
