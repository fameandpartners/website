require 'spec_helper'

describe 'products/dresses/search page', type: :feature, js: true do
  let!(:product_colour) { FactoryGirl.create(:product_colour) }
  let(:price) { '$289' }

  it 'displays product name' do
    visit "/dresses"

    within('.price') do
      expect(page).to have_content(price)
    end
  end

  context 'with promocode applied' do
    let(:current_promotion) { Spree::Promotion.new code: 'freestuff' }

    it 'displays product name' do
      allow_any_instance_of(ApplicationController).to receive(:current_promotion).and_return(current_promotion)
      visit "/dresses"

      within('.price') do
        expect(page).to have_content(price)
      end
    end
  end

end
