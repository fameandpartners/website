module Acceptance
  module ManualOrdersSteps

    step 'I am on the manual orders page' do
      visit '/fame_admin/manual_orders'
    end

    step 'The example user created with:' do |user_data|
      user_data = user_data.to_h
      address = create :address,
                 firstname: user_data['First Name'],
                 lastname: user_data['Last Name'],
                 email: user_data['Email'],
                 address1: user_data['Street Address'],
                 address2: user_data['Street Address 2'],
                 city: user_data['City'],
                 zipcode: user_data['Zipcode'],
                 phone: user_data['Phone Number']
      user = create :spree_user
      user.first_name = user_data['First Name']
      user.last_name = user_data['Last Name']
      user.email = user_data['Email']
      user.bill_address = address
      user.ship_address = address
      user.save
    end

    step 'The example completed order exists with this user' do
      order = create :complete_order
      user = Spree::User.last
      order.user = user
      order.bill_address_id = user.bill_address_id
      order.ship_address_id = user.ship_address_id
      order.save
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
      expect(page).to have_selector('h4.product_image img[src*=black-front-crop]')
    end

    step 'I select "Roger That" from chosen customers select box' do
      chosen_select('Roger That', from: '#forms_manual_order_existing_customer')
    end

    step 'I should see correct user data prefilled' do
      expect(page).to have_selector("//input[contains(@value,'Roger')]")
    end

  end
end

RSpec.configure do |config|
  config.include Chosen::Rspec::FeatureHelpers, type: :feature
  config.include Acceptance::ManualOrdersSteps, type: :feature
end
