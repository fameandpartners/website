module Acceptance
  module ProductSteps
    step 'I select :dress_size size' do |dress_size|
      # a with no href can't be accessed through click_link
      click_a_with_no_href( 'Size Profile')
      sleep 0.2 # User interacting with sidebar + animation
      click_a_with_no_href( dress_size)
      sleep 0.2 # User interacting with sidebar + animation
      expect(page).to have_selector('.pdp-side-menu', visible: false)
    end

    step 'I select :skirt_length skirt length' do |skirt_length|
      sleep 0.2 # User interacting with sidebar + animation
      fill_in 'height-option-cm', :with => skirt_length.downcase
      sleep 0.2 # User interacting with sidebar + animation
      expect(page).to have_selector('.pdp-side-menu', visible: false)
    end

    step 'I select the :color_name color' do |color_name|
      click_link 'Color'
      sleep 0.2 # User interacting with sidebar + animation
      click_link color_name
      sleep 0.2 # User interacting with sidebar + animation
      expect(page).to have_selector('.pdp-side-menu', visible: false)
    end

    step 'I save the profile' do
      find(:css,'.size-selection .btn-black').click
    end
    
    step 'I select the express making option checkbox' do
      checkbox = find(:css, '.pdp-side-container-fast-making label')
      checkbox.click
    end

    step 'I should see the express making option disabled' do
      expect(page).to have_unchecked_field('EXPRESS MAKING', visible: false)
    end

    step 'I should see add to cart link enabled' do
      add_to_bag_link = find("a", :text => "ADD TO BAG")
      expect(add_to_bag_link['class']).not_to have_text('btn-lowlight')
    end
 
    step "I add to bag" do
      find("a", :text => "ADD TO BAG").click      
    end
    
    def click_a_with_no_href( text )
      find("a", :text => text).click      
    end
    
  end
end

RSpec.configure do |config|
  config.include Acceptance::ProductSteps, type: :feature
end
