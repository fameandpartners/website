module Acceptance
  module Navigation
    module StoreSearchSteps
      step 'Search for :dress_name' do |dress_name|
        find('#search').click

        # Fill in and press enter
        fill_in 'searchValue', with: dress_name
        find('#search').click
      end

      step 'Search for an empty string' do
        find('#search').click

        # Fill in and  enter
        fill_in 'searchValue', with: ' '
        find('#search').click
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::Navigation::StoreSearchSteps, type: :feature
end
