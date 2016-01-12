FactoryGirl.define do
  factory :translation_banner, :class => Revolution::Translation::Banner do
    translation_id              1
    sequence(:alt_text)         { |n| "alt text #{n}" }
    size                        'full'
    sequence(:banner_order)     { |n| n }
    sequence(:banner_file_name) { |n| "image_#{n}.jpg" }
    banner_content_type         'image/jpeg'
    banner_file_size            72900
  end
end
