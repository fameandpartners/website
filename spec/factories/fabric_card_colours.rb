FactoryGirl.define do
  factory :fabric_card_colour do
    position      { rand(100).to_s }
    fabric_colour nil
    fabric_card   nil
  end
end
