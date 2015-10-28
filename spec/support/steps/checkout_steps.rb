module Acceptance
  module CheckoutSteps
    step 'I select :state_name state' do |state_name|
      find('#order_bill_address_attributes_state_id_chosen').click
      find('li.active-result', text: state_name).click
    end

    step 'I select :country_name country' do |country_name|
      find('#order_bill_address_attributes_country_id_chosen').click
      find('li.active-result', text: country_name).click
    end

    step 'I fill in expiry and CVC credit card fields:' do |cc_info|
      cc_info = cc_info.to_h

      fill_in 'month'    , with: cc_info['Expiration Month']
      fill_in 'year'     , with: cc_info['Expiration Year']
      fill_in 'card_code', with: cc_info['CVC']
    end

    step 'I should see my order placed, with :dress_name dress, :size_number size' do |dress_name, size_number|
      expect(page).to have_content('ORDER CONFIRMATION')
      expect(page).to have_content(dress_name)
      expect(page).to have_content("Size:#{size_number}")
    end
  end
end

RSpec.configure { |c| c.include Acceptance::CheckoutSteps, type: :feature }
