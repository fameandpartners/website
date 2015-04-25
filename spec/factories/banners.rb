FactoryGirl.define do
  factory :banner, :class => Spree::TaxonBanner do
    sequence(:title) { |n| "TaxonBanner Title - #{n}" }
    sequence(:description) { |n| "TaxonBanner Description - #{n}" }
  end
end
