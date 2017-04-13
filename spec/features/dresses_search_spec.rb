require 'spec_helper'

describe 'search page', type: :feature, js: true do
  let(:search_params) { '' }
  let(:current_promotion) { nil }

  before(:each) do
    color_option_type = FactoryGirl.create(:option_type, :color)
    size_option_type  = FactoryGirl.create(:option_type, :size)

    size_small = FactoryGirl.create(:option_value, name: 'US0/AU4', presentation: 'US0 / AU4', option_type: size_option_type)
    color_red  = FactoryGirl.create(:option_value, name: 'red', presentation: 'Red', option_type: color_option_type)

    @dress = FactoryGirl.create(:dress, name: 'Bianca Dress', sku: 'ABC123')
    taxon = FactoryGirl.create(:taxon, permalink: 'style/dress', name: 'dresses', published_at: Time.now)
    taxonomy = FactoryGirl.create(:taxonomy, name: 'Style')
    taxonomy.taxons << taxon
    @dress.taxons << taxon

    image = FactoryGirl.create(:image)
    FactoryGirl.create(:product_color_value, product: @dress, option_value: color_red, images: [image])

    FactoryGirl.create(:site_version, permalink: 'au')
    FactoryGirl.create(:site_version, permalink: 'us')
    Products::ColorVariantsIndexer.index!
  end

  shared_context 'product with price' do
    it 'displays product in search result' do
      allow_any_instance_of(ApplicationController).to receive(:current_promotion).and_return(current_promotion)
      visit "/dresses#{search_params}"

      within('.price') do
        expect(page).to have_content(@dress.price.to_s)
      end
    end
  end

  context 'with no params' do
    it_behaves_like 'product with price'
  end

  context 'with autopromotion' do
    let(:current_promotion) { Spree::Promotion.new code: 'freestuff' }
    it_behaves_like 'product with price'
  end

  context 'with plain text search' do
    let(:search_params) { '?q=red' }
    it_behaves_like 'product with price'
  end

  context 'with color_group as single value param' do
    let(:search_params) { '?color_group=red' }
    it_behaves_like 'product with price'
  end

  context 'with color_group as array param' do
    let(:search_params) { '?color_group[]=red' }
    it_behaves_like 'product with price'
  end

  context 'with unrelated plain text search' do
    let(:search_params) { '?q=non-related-to-product-string' }

    it 'should render no products' do
      visit "/dresses#{search_params}"

      expect(page).not_to have_css('.price')
    end
  end

end
