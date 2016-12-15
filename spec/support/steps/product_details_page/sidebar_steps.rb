module Acceptance
  module ProductDetailsPage
    module SidebarSteps
      SIDEBAR_COLOR_SELECTOR = '.pdp-side-container-color .c-card-customize__content__right'.freeze

      # Colors
      step 'I see the :color_name color selected' do |color_name|
        within SIDEBAR_COLOR_SELECTOR do
          expect(page).to have_content(color_name)
        end
      end

      step 'I do not see the :color_name color selected' do |color_name|
        within SIDEBAR_COLOR_SELECTOR do
          expect(page).not_to have_content(color_name)
        end
      end

      step 'I see no color selected' do
        color_div = page.find(SIDEBAR_COLOR_SELECTOR)

        expect(color_div).not_to have_css('.is-selected')
        within color_div do
          expect(page).to have_content('')
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::ProductDetailsPage::SidebarSteps, type: :feature
end
