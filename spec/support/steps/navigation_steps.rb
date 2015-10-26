module Acceptance
  module NavigationSteps
    module Browsing
      include PathBuildersHelper

      step 'I am on the homepage' do
        visit '/'
      end

      step 'I am on :dress_name dress page' do |dress_name|
        dress = Spree::Product.find_by_name(dress_name)
        visit collection_product_path(dress)
      end

      step 'I select :dress_size size' do |dress_size|
        # find('#product-size-action').click
      end
    end

    module Expectations
      step 'I should see :content' do |content|
        expect(page).to have_content(content)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::NavigationSteps::Browsing, type: :feature
  config.include Acceptance::NavigationSteps::Expectations, type: :feature
end
