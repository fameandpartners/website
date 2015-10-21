FactoryGirl.define do
  factory :spree_zone, class: Spree::Zone do
    name         {|zone| generate(:name) }
    description  {|zone| zone.name }
  end

  factory :site_version, class: SiteVersion do
    name      { generate(:name) }
    permalink { generate(:permalink) }
    active    true
    association :zone, factory: :spree_zone
    exchange_rate 1.0
  end

  trait :us do
    name 'USA'
    permalink 'us'
    default true
    active true
    currency 'USD'
    locale 'en-US'
  end

  trait :au do
    name 'Australia'
    permalink 'au'
    default false
    active true
    currency 'AUD'
    locale 'en-AU'
  end
end
