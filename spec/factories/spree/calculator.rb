require 'spree/core/testing_support/factories/calculator_factory'

FactoryGirl.define do
  factory :simple_calculator, :class => Spree::Calculator::FlatRate do
  end
end
