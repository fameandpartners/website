FactoryGirl.define do
  factory :customisation_value, class: CustomisationValue do
    price { 10 + rand(100) / 10.0 } # rails will convert to big decimal
    price_aud { 10 + rand(100) / 10.0 } # rails will convert to big decimal


    sequence(:name) { |n| "make-skirt-ankle-length-#{n}" }
    sequence(:presentation) { |n| "Make Skirt Ankle Length #{n}" }
    sequence(:position) { |sequence| sequence }
    customisation_type 'cut'

    # Note: do NOT iterate over `CustomisationValue::AVAILABLE_CUSTOMISATION_TYPES` for "DRY" purposes on test factories
    # This IS a case of intentional duplication.
    trait :cut do
      customisation_type 'cut'
    end

    trait :fabric do
      customisation_type 'fabric'
    end

    trait :length do
      customisation_type 'length'
    end

    trait :fit do
      customisation_type 'fit'
    end

    trait :style do
      customisation_type 'style'
    end
  end
end
