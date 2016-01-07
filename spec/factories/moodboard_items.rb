require 'ffaker'


FactoryGirl.define do
  factory :moodboard_item do
    moodboard
    product_id                { create(:spree_product).id }
    uuid                      { SecureRandom.uuid }
    product_color_value_id    317
    color_id                  38
    user_id                   { moodboard.user_id }
  end
end
