# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_return_event do
    item_return_uuid "MyString"
    event_type "MyString"
    data "MyText"
    created_at "2015-06-23 13:49:10"
    occurred_at "2015-06-23 13:49:10"
  end
end
