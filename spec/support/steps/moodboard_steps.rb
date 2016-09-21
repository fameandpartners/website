module Acceptance
  module MoodboardSteps
    step 'I add ":dress_name" to my moodboard' do |dress_name|
      within('.details') do
        expect(page).to have_text(dress_name.upcase)

        expect(page).to have_text('+Moodboard')
        click_link '+Moodboard'

        expect(page).to have_text('Wishlist')
        click_link 'Wishlist'

        expect(page).to have_selector('i.fa-check')
      end
    end

    step 'I remove ":dress_name" from my moodboard' do |dress_name|
      within('.panel-product') do
        expect(page).to have_text(dress_name)
        find('a', text: 'Remove').click
      end
    end

    step 'I view my moodboard' do
      visit '/wishlist'
    end

    step 'I should have ":dress_name" on my moodboard' do |dress_name|
      send 'I view my moodboard'
      expect(page).to have_text(dress_name)
    end
  end
end

RSpec.configure { |c| c.include Acceptance::MoodboardSteps, type: :feature }
