FactoryGirl.define do
  factory :customisation_value do
    price { 10 + rand(100) / 10.0 } # rails will convert to big decimal
    name { Faker::Name.first_name }
    presentation { Faker::Name.first_name }
    sequence(:position) { |n| n }
  end
end
