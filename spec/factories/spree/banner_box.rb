FactoryGirl.define do
  factory :banner_box, class: Spree::BannerBox do
    url        { Faker::Internet.uri(%w(http https).sample) }
    category   { Faker::Lorem.word }
    css_class  { Faker::Lorem.word }
    is_small   true
    enabled    true
    attachment { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'factories', 'fixtures', 'pixel.png'), 'image/png') }
  end
end
