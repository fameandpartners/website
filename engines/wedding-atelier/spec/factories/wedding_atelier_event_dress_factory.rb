FactoryGirl.define do
  factory :wedding_atelier_event_dress, class: WeddingAtelier::EventDress do
    association :product, factory: :spree_product
    association :user, factory: :spree_user
    association :event, factory: :wedding_atelier_event

    association :color, factory: :option_value
    association :size, factory: :option_value

    height { "5'1\"/155cm" }

    fit { FactoryGirl.build(:customisation_value, :fit) }
    style { FactoryGirl.build(:customisation_value, :style) }
    fabric { FactoryGirl.build(:customisation_value, :fabric) }
    length { FactoryGirl.build(:customisation_value, :length) }
  end
end
