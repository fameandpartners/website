FactoryGirl.define do
  factory :shipping_method, class: Spree::ShippingMethod do
    name        'DHL'
    zone        { Spree::Zone.first || Spree::Zone.create(name: 'us') }
    calculator  { Spree::Calculator::SaleShipping.new }
    display_on  'back_end'
    match_none  false
    match_all   false
    match_one   false
  end
end
