module Acceptance
  module CheckoutSteps
    step 'I should see the cart sidebar with the checkout button' do
      expect(page).to have_text('SHOPPING BAG')
      expect(page).to have_button('CHECKOUT')
    end

    step 'I select :state_name state' do |state_name|
      find('#order_bill_address_attributes_state_id_chosen').click
      find('li.active-result', text: state_name).click
    end

    step 'I select :country_name country' do |country_name|
      find('#order_bill_address_attributes_country_id_chosen').click
      find('li.active-result', text: country_name).click
    end

    step 'I select :country_name country and :state_name state' do |country_name, state_name|
      find('#order_bill_address_attributes_country_id_chosen').click
      find('li.active-result', text: country_name).click

      if country_name == 'New Zealand'
        find('#order_bill_address_attributes_state_name').set(state_name)
      else
        find('#order_bill_address_attributes_state_id_chosen').click
        find('li.active-result', text: state_name).click
      end
    end

    step 'I should see shipping to :country_name warning' do |country_name|
      expect(page).to have_text("#{country_name.upcase} ORDERS")
      expect(page).to have_text('Additional custom duty fees apply to your selected country.')
    end

    step 'I agree with shipping fee' do
      find('#international_shipping_fee').click
    end

    step 'I fill in credit card information:' do |cc_info|
      cc_info = cc_info.to_h

      fill_in 'Name on card', with: cc_info['Name on card']
      fill_in 'Card number', with: cc_info['Card number']
      fill_in 'month', with: cc_info['Expiration Month']
      fill_in 'year', with: cc_info['Expiration Year']
      fill_in 'card_code', with: cc_info['CVC']
    end

    step 'I should see my order placed, with :dress_name dress, :size_number size and :dress_price price' do |dress_name, dress_size, dress_price|
      dress_size_without_spaces = dress_size.delete(' ') # e.g. US10

      expect(page).to have_content('Thanks for  your order!')
      expect(page).to have_content('Your dresses are being made...')
      expect(page).to have_content(dress_name.upcase)
      expect(page).to have_content(dress_price)
      expect(page).to have_content(dress_size_without_spaces)
    end
  end
end

RSpec.configure { |c| c.include Acceptance::CheckoutSteps, type: :feature }
