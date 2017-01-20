FactoryGirl.define do
  factory :wedding_atelier_event_dress, class: WeddingAtelier::EventDress do
    association :product, factory: :spree_product
    association :user, factory: :spree_user
    association :event, factory: :wedding_atelier_event
    association :color, factory: :option_value
    association :fit, factory: :customisation_value
    association :style, factory: :customisation_value
    association :fabric, factory: :customisation_value
    association :size, factory: :option_value
    association :length, factory: :customisation_value
    height { 'petite' }
  end
end
