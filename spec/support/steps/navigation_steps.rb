module NavigationSteps
  step 'I am on the homepage' do
    visit '/'
  end

  step 'I click on :element' do |element|
    click_on element
  end

  step 'I view dress :dress_name' do |dress_name|
    find("img[alt='#{dress_name}']").click
  end


  step 'I choose size :size' do |size|
    # binding.pry
    find('#product-size-action').trigger('click')
    find(%Q(.size-option[data-name="US #{size}"])).trigger('click')
  end

  step 'I add the dress to my cart' do
    click_on 'Add to Cart'
  end
end

RSpec.configure { |c| c.include NavigationSteps }