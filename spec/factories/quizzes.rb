FactoryGirl.define do
  factory :quiz, class: Quiz do
    name 'Style Quiz'

    trait :wedding do
      name 'Wedding Quiz'
    end

    trait :style do
      name 'Style Quiz'
    end
  end
end
