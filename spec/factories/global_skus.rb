FactoryGirl.define do
  factory :global_sku do
    sku { Faker.bothify("???####US##AU##C#X#H?").upcase }
  end
end
