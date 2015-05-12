FactoryGirl.define do
  factory :fabrication do
    state { Fabrication::STATES.keys.sample }
  end
end
