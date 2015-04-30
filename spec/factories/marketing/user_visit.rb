# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_user_visit, class: Marketing::UserVisit do
    visits        { 1 + rand(10) }
    utm_campaign  { generate(:utm_campaign) }
    referrer      { 'http://external.place.with.ad' }
  end
end
