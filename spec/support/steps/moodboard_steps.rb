module Acceptance
  module MoodboardSteps
    step 'I add ":dress_name" to my moodboard' do |dress_name|
      within('.details') do
        expect(page).to have_content(dress_name.upcase)
        first('.moodboard').click
      end
    end

    step 'I remove ":dress_name" from my moodboard' do |dress_name|
      within('.product-item') do
        expect(page).to have_content(dress_name.upcase)
        find('a', text: 'Remove').click
      end
    end

    step 'I view my moodboard' do
      visit '/wishlist'
    end

    step 'I should have ":dress_name" on my moodboard' do |dress_name|
      send 'I view my moodboard'
        expect(page).to have_content(dress_name.upcase)
    end
  end
end

RSpec.configure { |c| c.include Acceptance::MoodboardSteps, type: :feature }
