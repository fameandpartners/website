module NavigationSteps
  step 'I am on the homepage' do
    visit '/'
  end

  step 'I click on :element' do |element|
    click_on element
  end
end

RSpec.configure { |c| c.include NavigationSteps }