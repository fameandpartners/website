FactoryGirl.define do
  factory :taxon, :class => Spree::Taxon do
    sequence(:name) { |n| "Taxon-#{n}" }
    sequence(:position)
    permalink { name.downcase.gsub(/\s/, '_')  }
  end

  factory :blank_taxon, class: Spree::Taxon do
    created_at { Date.today }
    updated_at { Date.today }
  end
  
end
