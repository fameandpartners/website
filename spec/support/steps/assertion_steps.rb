module AssertionSteps
  step 'I should see :content' do |content|
    expect(page).to have_content content
  end
end

RSpec.configure { |c| c.include AssertionSteps }