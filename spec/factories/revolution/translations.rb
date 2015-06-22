FactoryGirl.define do
  factory :revolution_translation, class: Revolution::Translation do
    title 'Translation Title'
    meta_description 'Translation Meta Description'
    locale 'en-AU'
    association :page, factory: :revolution_page
  end
end
