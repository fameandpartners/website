FactoryGirl.define do
  factory :spree_zone, class: Spree::Zone do
    name         {|zone| generate(:name) }
    description  {|zone| zone.name }
  end

  factory :site_version, class: SiteVersion do
    name      { generate(:name) }
    permalink { generate(:permalink) }
    association :zone, factory: :spree_zone
    exchange_rate 1.0
  end
end
