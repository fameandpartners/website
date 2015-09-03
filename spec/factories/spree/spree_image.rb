FactoryGirl.define do
  sequence(:image_name) { |n| "some-great-kitty-picture-#{ n }" }

  factory :spree_image, :class => Spree::Image do
    attachment_width        2560
    attachment_height       1164
    attachment_file_size    118319
    attachment_content_type 'image/jpg'
    attachment_updated_at   { 3.days.ago }
    attachment_file_name    { generate(:image_name) }
    type                    'Spree::Image'
  end
end
