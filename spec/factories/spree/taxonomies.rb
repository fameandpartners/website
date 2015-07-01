FactoryGirl.modify do
  factory :taxonomy, :class => Spree::Taxonomy do
    sequence(:name)

    trait :outerwear do
      name { Spree::Taxonomy::OUTERWEAR_NAME }
    end
  end
end
