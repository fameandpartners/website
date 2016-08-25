module Acceptance
  module ManualOrdersSteps

    step 'I am on the new manual order page' do
      visit '/fame_admin/manual_orders/new'
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
                 phone: user_data['Phone Number'],
                 country: Spree::Country.where(name: user_data['Country']).first,
                 state: Spree::State.where(name: user_data['State']).first
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

    step 'I select skirt length "Standard" from chosen length select box' do
      chosen_select('Standard', from: '#forms_manual_order_length')
    end

    step 'I select "Black" color from chosen color select box' do
      chosen_select('Black', from: '#forms_manual_order_color')
    end

    step 'I select "Australia" from chosen country select box' do
      chosen_select('Australia', from: '#forms_manual_order_currency')
    end

    step 'I should have black dress image' do
      expect(page).to have_selector('h4.product_image img[src*=black-front-crop]')
    end

    step 'I select "Roger That" from chosen customers select box' do
      chosen_select('Roger That', from: '#forms_manual_order_existing_customer')
      trigger_poltergeist_event(field_id: '#forms_manual_order_existing_customer_chosen', event: 'focus')
    end

    step 'I should see correct user data prefilled' do
      expect(page).to have_field('forms_manual_order_first_name', with: 'Roger')
      expect(page).to have_field('forms_manual_order_last_name', with: 'That')
      expect(page).to have_field('forms_manual_order_email', with: 'test@email.com')
      expect(page).to have_field('forms_manual_order_address1', with: 'Street X')
      expect(page).to have_field('forms_manual_order_address2', with: 'House Y')
      expect(page).to have_field('forms_manual_order_city', with: 'Melbourne')
      expect(page).to have_field('forms_manual_order_phone', with: '2255-4422')
      expect(page).to have_field('forms_manual_order_zipcode', with: '12345')
      expect(page).to have_selector('#forms_manual_order_country_chosen a span', text: 'United States')
      expect(page).to have_selector('#forms_manual_order_state_chosen a span', text: 'California')
    end

    private

    def trigger_poltergeist_event(field_id:, event: :focus)
      find(field_id).trigger(event) if Capybara.current_driver == :poltergeist
    end
  end
end

RSpec.configure do |config|
  config.include Chosen::Rspec::FeatureHelpers, type: :feature
  config.include Acceptance::ManualOrdersSteps, type: :feature
end
