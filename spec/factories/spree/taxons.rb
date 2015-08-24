FactoryGirl.define do
  factory :taxon, :class => Spree::Taxon do
    sequence(:name) { |n| "Taxon-#{n}" }
    sequence(:position)
    permalink { name.downcase.gsub(/\s/, '_')  }

    trait :jackets do
      permalink { Spree::Taxon::JACKETS_PERMALINK }
    end
  end
end
