FactoryGirl.modify do
  factory :taxon, :class => Spree::Taxon do
    sequence(:name) { |n| "Taxon-#{n}" }
    sequence(:position)
    permalink { name.downcase.gsub(/\s/, '_')  }
  end
end
