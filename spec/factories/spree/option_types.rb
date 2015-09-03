FactoryGirl.define do
  factory :option_type, :class => Spree::OptionType do
    name 'foo-size'
    presentation 'Size'

    trait :color do
      name 'dress-color'
      presentation 'Color'
    end

    trait :size do
      name 'dress-size'
      presentation 'Size'
    end

    trait :with_values do
      after(:create) do |instance|
        2.times do |index|
          option = build(:option_value, instance.name.to_s,
            name: "#{ instance.name } #{ index }",
            presentation:  "#{ instance.name } #{ index }",
            option_type: instance
          )
          option.save(validate: false)
        end
      end
    end

    trait :with_values_groups do
      after(:create) do |instance|
        2.times do |index|
          option = build(:option_value, instance.name.to_s,
            option_values_groups: [create(:option_values_group, option_type: instance)],
            name: "#{ instance.name } #{ index }",
            presentation:  "#{ instance.name } #{ index }",
            option_type: instance
          )
          option.save(validate: false)
        end
      end
    end
  end
end
