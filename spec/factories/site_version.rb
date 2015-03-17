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

=begin
    t.integer  "zone_id"
    t.string   "name"
    t.string   "permalink"
    t.boolean  "default",                 :default => false
    t.boolean  "active",                  :default => false
    t.string   "currency"
    t.string   "locale"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.date     "exchange_rate_timestamp"
    t.decimal  "exchange_rate",           :default => 1.0
=end
