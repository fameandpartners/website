module Acceptance
  module Navigation
    module BrowsingSteps
      include PathBuildersHelper

      step 'I am on the homepage' do
        visit '/'
      end

      step 'I am on :dress_name dress page' do |dress_name|
        dress = Spree::Product.find_by_name(dress_name)
        visit collection_product_path(dress)
      end

      step 'I click on :button_text button' do |button_text|
        click_button button_text
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::Navigation::BrowsingSteps, type: :feature
end
