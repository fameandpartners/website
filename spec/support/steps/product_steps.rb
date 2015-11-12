module Acceptance
  module ProductSteps
    step 'I select :dress_size size' do |dress_size|
      find('#product-size-action', visible: true).click
      find(:link, dress_size, visible: true).trigger('click')
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::ProductSteps, type: :feature
end
