FactoryGirl.define do
  factory :simple_payment_method, :class => Spree::PaymentMethod::Check do
    name 'Check'
    environment 'test'
  end
end
