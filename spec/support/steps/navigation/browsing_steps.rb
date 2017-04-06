module Acceptance
  module Navigation
    module BrowsingSteps
      include PathBuildersHelper

      step 'I am on the homepage' do
        visit '/'
      end

      step 'I visit the dresses page' do
        visit '/dresses'
      end

      step 'I visit the :path path' do |path|
        visit path
      end

      step 'I am on :dress_name dress page' do |dress_name|
        dress = Spree::Product.where(name: dress_name).first
        visit collection_product_path(dress)
      end

      step 'I click on element with text :text' do |text|
        find(:xpath, "//*[text()='#{text}']").click
      end

      step 'I click on :button_text button' do |button_text|
        click_button button_text
      end

      step 'I click on :link_text link' do |link_text|
        click_link link_text
      end

      step 'I select :site_version site version' do |site_version|
        find('#locale-selector-current').click
        click_link site_version
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::Navigation::BrowsingSteps, type: :feature
end
