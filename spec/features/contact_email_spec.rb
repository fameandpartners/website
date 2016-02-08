require 'spec_helper'

describe 'sending a contact email', :type => :feature do
  describe 'smoke test' do
    it 'works', :chrome do
      contact = build :contact

      visit '/'
      click_link 'Contact Us'
      within('#new_contact') do
        fill_in 'First name', :with => contact.first_name
        fill_in 'Last name', :with => contact.last_name
        fill_in 'Email', :with => contact.email
        fill_in 'Phone', :with => contact.phone
        fill_in 'Your Message', :with => contact.message
        fill_in 'Order number', :with => contact.order_number
      end
      click_button 'Send'

      expect(page).to have_content "THANKS!"
      expect(page).to have_content "WE WON'T PLAY HARD TO GET, WE'LL GET BACK TO YOU ASAP."
    end
  end
end
