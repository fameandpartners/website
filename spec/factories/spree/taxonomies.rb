FactoryGirl.define do
  factory :taxonomy, :class => Spree::Taxonomy do
    sequence(:name)

    trait :outerwear do
      name { Spree::Taxonomy::OUTERWEAR_NAME }
    end

    trait :collection do
      name 'Range'

      after(:create) do |taxonomy|
        taxonomy.root.children = build_list(:taxon, 3, taxonomy_id: taxonomy.id)
      end
    end

    trait :style do
      name 'Style'

      after(:create) do |taxonomy|
        taxonomy.root.children = [
          build(:taxon, taxonomy_id: taxonomy.id, name: "Plus Size"),
          build(:taxon, taxonomy_id: taxonomy.id, name: "Mini"),
          build(:taxon, taxonomy_id: taxonomy.id, name: "Midi"),
          build(:taxon, taxonomy_id: taxonomy.id, name: "Maxi")
        ]
      end
    end
  end
end
