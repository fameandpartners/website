FactoryGirl.define do
  factory :wedding_atelier_invitation, class: WeddingAtelier::Invitation do
    state 'pending'
    user_email { Faker::Internet.email }
    event_slug { "#{Faker::Name.first_name}-wedding"  }
  end
end
