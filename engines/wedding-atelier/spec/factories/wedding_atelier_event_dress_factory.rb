FactoryGirl.define do
  factory :wedding_atelier_event_dress, class: WeddingAtelier::EventDress do
    product
    user
    association :event, factory: :wedding_atelier_event
    association :color, factory: :option_value
    association :fit, factory: :option_value
    association :style, factory: :option_value
    association :fabric, factory: :option_value
    association :size, factory: :option_value
    association :length, factory: :option_value
  end
end
