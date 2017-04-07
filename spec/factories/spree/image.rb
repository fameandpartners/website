FactoryGirl.define do
  factory :image, class: Spree::Image do
    # Ref: https://github.com/spree/spree/blob/e8ef8ac6b77369318f63e6715174871e19df5577/core/lib/spree/testing_support/factories/image_factory.rb
    attachment { File.new(Rails.root.to_s + '/spec/fixtures/' + 'thinking-cat.jpg') }
  end
end
