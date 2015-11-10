FactoryGirl.define do
  factory :spree_zone, class: Spree::Zone do
    name         {|zone| generate(:name) }
    description  {|zone| zone.name }
  end

  factory :site_version, class: SiteVersion do
    ignore do
      countries_currencies { {'AU' => 'AUD', 'US' => 'USD', 'UK' => 'GBP'} }
      currencies           { countries_currencies.values }
      iso_name             { countries_currencies.keys.sample }
    end

    name        { iso_name }
    permalink   { name.to_s.downcase }
    currency    { countries_currencies.fetch(name) { currencies.sample } }

    locale      { "en-#{name}" }
    association :zone, factory: :spree_zone
    exchange_rate 1.0

    trait(:us)      { name    { 'US' } }
    trait(:au)      { name    { 'AU' } }
    trait(:uk)      { name    { 'UK' } }
    trait(:default) { default { true } }
  end
end
