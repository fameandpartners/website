module Acceptance
  module CheckoutSteps
    step 'I should see the cart sidebar with the checkout button' do
      expect(page).to have_text('Shopping Bag')
      expect(page).to have_button('CHECKOUT')
    end

    step 'I select :state_name state' do |state_name|
      find('#order_bill_address_attributes_state_id_chosen').click
      find('li.active-result', text: state_name).click
    end

    step 'I select :country_name country' do |country_name|
      find('#order_bill_address_attributes_country_id_chosen').click
      click_layered_element(:css, 'li.active-result', text: country_name)
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

      expect(page).to have_content('ORDER CONFIRMATION')
      expect(page).to have_content(dress_name)
      expect(page).to have_content(dress_price)
      expect(page).to have_content(dress_size_without_spaces)
    end
  end
end

RSpec.configure { |c| c.include Acceptance::CheckoutSteps, type: :feature }
