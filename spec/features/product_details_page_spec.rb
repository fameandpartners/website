require 'spec_helper'

describe 'product details page', type: :feature do

  let(:product) do
    FactoryGirl.create(:dress_with_variants).tap do |dress|
      dress.set_property('product_type', "the awesome prop")
    end
  end

  it 'displays product name and product type' do
    visit "/dresses/dress-#{product.id}"

    within('h1.heading') do
      expect(page).to have_content(product.name)
    end

    within('h2.heading') do
      expect(page).to have_content("the awesome prop")
    end
  end
end
