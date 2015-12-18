module Acceptance
  module ProductSteps
    step 'I select :dress_size size' do |dress_size|
      find('#product-size-action').click
      click_layered_element(:link, dress_size)
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::ProductSteps, type: :feature
end
