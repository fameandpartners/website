module Acceptance
  module ProductSteps
    step 'I select :dress_size size' do |dress_size|
      find('#product-size-action').click
      click_layered_element(:link, dress_size)
    end
    step 'I select :my_height height' do |my_height|
      find('#product-height-action').click
      screenshot_and_open_image
      click_layered_element(:link, my_height)
      screenshot_and_open_image
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::ProductSteps, type: :feature
end
