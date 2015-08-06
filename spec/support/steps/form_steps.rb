module FormSteps
  step 'I fill the details:' do |table|


    table.hashes.map do |row|
      # binding.pry
      res = fill_in row['field'], :with => row['value']
      expect(res).to be_truthy
    end
    # screenshot_and_open_image
    # binding.pry
  end

  step 'I select :value from :select_input' do |value, select_input|
    # binding.pry

    select value, :from => select_input
  end
end

RSpec.configure { |c| c.include FormSteps }