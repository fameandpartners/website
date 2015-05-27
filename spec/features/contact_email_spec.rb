require 'spec_helper'

describe 'sending a contact email', :type => :feature do
  describe 'smoke test' do
    it do
      contact = build :contact

      visit '/'
      click_link 'Contact Us'
      within('#new_contact') do
        fill_in 'First name', :with => contact.first_name
        fill_in 'Last name', :with => contact.last_name
        fill_in 'Email', :with => contact.email
        fill_in 'Phone', :with => contact.phone
        fill_in 'Message', :with => contact.message
        fill_in 'Order number', :with => contact.order_number
      end
      click_button 'Send'

      expect(page).to have_content "Thanks!"
      expect(page).to have_content "We won't play hard to get, we'll get back to you ASAP."
    end
  end
end
