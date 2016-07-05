module Acceptance
  module ManualOrdersSteps

    step 'I am on the manual orders page' do
      visit '/fame_admin/manual_orders'
    end

    step 'I select "Connie" product from chosen style name select box' do
      chosen_select('Connie (SKU: 4B453)', from: '#forms_manual_order_style_name')
    end

    step 'I select size "US4/AU8" from chosen size select box' do
      chosen_select('US4/AU8', from: '#forms_manual_order_size')
    end

    step 'I select skirt length "Standart" from chosen length select box' do
      chosen_select('Standart', from: '#forms_manual_order_length')
    end

    step 'I select "Black" color from chosen color select box' do
      chosen_select('Black', from: '#forms_manual_order_color')
    end

    step 'I select "Australia" from chosen country select box' do
      chosen_select('Australia', from: '#forms_manual_order_site_version')
    end

    step 'I should have black dress image' do
      page.should have_selector('h4.product_image img[src*=black-front-crop]')
    end

  end
end

RSpec.configure do |config|
  config.include Chosen::Rspec::FeatureHelpers, type: :feature
  config.include Acceptance::ManualOrdersSteps, type: :feature
end
