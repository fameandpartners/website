require 'spec_helper'

describe 'Seo Helpers' do
 include CommonHelper

  let(:au)                    { false }
  let(:current_site_version)  { double(SiteVersion, :is_australia? => au) }
  let(:request)               { double('Request', :fullpath => '/blah/vtha') }

  before do
    allow(self).to receive(:get_host).and_return('fameandpartners.test')
  end

  describe '#get_canonical_href' do

    it 'should generate path' do
      expect(get_canonical_href).to eq 'http://fameandpartners.test/blah/vtha'
    end

    context 'is_australian?' do
      let(:au) { true}
      it 'should generate au path' do
        expect(get_canonical_href).to eq 'http://fameandpartners.test/au/blah/vtha'
      end
    end

    context 'product canonical' do
      let(:product) { double(Spree::Product, :name => 'fancy-dress', :default_color => 'mauve') }
      before do
        @product = product
        allow(self).to receive(:collection_product_path).with(product).and_return("/#{product.name}")
      end

      it 'should generate canonical product path' do
        expect(get_canonical_href).to eq 'http://fameandpartners.test/fancy-dress/mauve'
      end

    end

 end

  #  get_hreflang
  #  get_canonical_href

 end
