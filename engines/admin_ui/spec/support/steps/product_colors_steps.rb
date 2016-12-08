module Acceptance
  module ProductColorsSteps

    step 'I am on the product colors page' do
      visit '/fame_admin/customisation/product_colors'
    end

    step 'I select "Connie" product from chosen select box' do
      chosen_select('Connie (SKU: 4B453)', from: '#product_color_value_product_id')
    end

    step 'I select "Coral" color from chosen select box' do
      chosen_select('coral', from: '#product_color_value_option_value_id')
    end

  end
end

RSpec.configure do |config|
  config.include Chosen::Rspec::FeatureHelpers, type: :feature
  config.include Acceptance::ProductColorsSteps, type: :feature
end
