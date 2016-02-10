module Acceptance
  module ProductSteps
    step 'I select :dress_size size' do |dress_size|
      find('#product-size-action').click
      click_layered_element(:link, dress_size)
      expect(page).to have_selector('#product-overlay', visible: false)
    end

    step 'I select :skirt_length skirt length' do |skirt_length|
      find('#product-height-action').click
      click_layered_element(:link, skirt_length)
      expect(page).to have_selector('#product-overlay', visible: false)
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::ProductSteps, type: :feature
end
