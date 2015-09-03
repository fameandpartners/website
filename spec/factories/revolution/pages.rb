FactoryGirl.define do
  factory :revolution_page, class: Revolution::Page do
    path '/a/path'

    trait :collection do
      path          '/dresses'
      template_path '/products/collections/show'
      variables     { { 'limit' => 21 } }
    end
  end
end
