require 'spec_helper'

describe 'product details page', type: :feature, js: true do

  let(:product) { FactoryGirl.create(:dress_with_variants) }

  xit 'displays product name and product type' do
    product.set_property('product_type', "the awesome prop")
    visit "/dresses/dress-#{product.id}"

    within('h1.heading') do
      expect(page).to have_content(product.name)
    end

    within('h4.subheading') do
      expect(page).to have_content("the awesome prop")
    end

    text = 'the awesome prop'
    meta = "meta[itemprop=\"category\"][content=\"#{text}\"]"
    expect(page).to have_css(meta, visible: false)

    expect(page).to have_content('Estimated delivery, 7 - 10 business days')
  end

  xit "doesn't display type and displays default meta" do
    visit "/dresses/dress-#{product.id}"

    within('h1.heading') do
      expect(page).to have_content(product.name)
    end

    expect(page).not_to have_css('h2.heading')

    text = 'Apparel & Accessories > Clothing > Dresses'
    meta = "meta[itemprop=\"category\"][content=\"#{text}\"]"
    expect(page).to have_css(meta, visible: false)
  end
end
