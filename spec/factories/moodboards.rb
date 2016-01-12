require 'ffaker'

FactoryGirl.define do
  factory :moodboard do
    association(:user, factory: :spree_user)
    name        { Faker::HipsterIpsum.words(4).to_sentence }
    purpose     'wedding'
    event_date  { Date.today + 60.days }
    description { Faker::HipsterIpsum.words(4).to_sentence }
  end
end
