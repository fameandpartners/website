FactoryGirl.define do
  factory :wedding_atelier_invitation, class: WeddingAtelier::Invitation do
    state 'pending'
    user_email { Faker::Internet.email }
    association :inviter, factory: :spree_user
    association :event, factory: :wedding_atelier_event
  end
end
