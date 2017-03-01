FactoryGirl.define do
  factory :wedding_atelier_user_profile, class: WeddingAtelier::UserProfile do
    height { WeddingAtelier::Height.definitions[:petite].sample }
    trend_updates { false }
    association :dress_size, factory: :option_value
  end
end
