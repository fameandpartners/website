FactoryGirl.define do
  factory :wedding_atelier_event, class: WeddingAtelier::Event do
    event_type 'wedding'
    number_of_assistants 2
    date { Date.today }
    name { "#{Faker::Name.first_name} Wedding"  }
  end
end
