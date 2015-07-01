FactoryGirl.modify do
  factory :taxonomy, :class => Spree::Taxonomy do
    sequence(:name)
  end
end
