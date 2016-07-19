module Acceptance
  module ProductSteps
    step 'I select :dress_size size' do |dress_size|
      click_link 'Dress Size'
      click_link dress_size
      find('.btn-close.lg').click
      expect(page).to have_selector('.pdp-side-menu', visible: false)
    end

    step 'I select :skirt_length skirt length' do |skirt_length|
      click_link 'Skirt Length'
      click_link skirt_length.downcase
      find('.btn-close.lg').click
      expect(page).to have_selector('.pdp-side-menu', visible: false)
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::ProductSteps, type: :feature
end
