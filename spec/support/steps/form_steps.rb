module Acceptance
  module FormSteps
    step 'I fill in form fields with:' do |fields|
      fields.each { |input_label, value| fill_in input_label, with: value }
    end
  end
end

RSpec.configure { |c| c.include Acceptance::FormSteps, type: :feature }
