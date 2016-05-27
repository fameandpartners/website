module Acceptance
  module DataLayerSteps
    step 'Page should have dataLayer :sku SKU from a variant' do |sku|
      expect(page.body).to have_text(%Q{"variant":{"sku":"#{sku}"}})
    end

    step 'Page should have dataLayer :product_name product' do |product_name|
      expect(page.body).to have_text('"product":{')
      expect(page.body).to have_text(%Q{"name":"#{product_name}"})
    end

    step 'Page should have dataLayer :event_name event' do |event_name|
      expect(page.body).to have_text(%Q{"event":"#{event_name}"})
    end
  end
end

RSpec.configure { |c| c.include Acceptance::DataLayerSteps, type: :feature }
