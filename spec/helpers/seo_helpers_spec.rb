require 'spec_helper'

describe 'Seo Helpers', type: :helper do
  include CommonHelper

  before(:each) do
    allow(helper).to receive(:request).and_return(request_double)
  end

  describe '#get_href_lang' do
    let!(:au_site_version) { create(:site_version, :au) }
    let!(:us_site_version) { create(:site_version, :us) }
    let!(:request_double)  { double('Request', url: 'http://us.lvh.me/blah/vtha?query=string') }

    subject(:href) { helper.get_hreflang(lang) }

    context 'given AU website' do
      let(:lang) { :au }

      it 'returns the AU url' do
        expect(subject).to eq('http://au.lvh.me/blah/vtha?query=string')
      end
    end

    context 'given US website' do
      let(:lang) { :us }

      it 'returns the US url' do
        expect(subject).to eq('http://us.lvh.me/blah/vtha?query=string')
      end
    end
  end

  describe '#get_canonical_href' do
    let!(:request_double)  { double('Request', url: 'http://us.lvh.me/blah/vtha?query=string') }

    subject { helper.get_canonical_href }

    it 'should generate path' do
      expect(subject).to eq 'http://us.lvh.me/blah/vtha'
    end

    context 'product canonical' do
      let(:product) { instance_double(Spree::Product, name: 'fancy-dress') }

      before do
        helper.instance_variable_set(:@product, product)
        allow(helper).to receive(:collection_product_path).with(product).and_return("/#{product.name}")
      end

      it 'should generate canonical product path' do
        expect(subject).to eq 'http://us.lvh.me/fancy-dress'
      end
    end

    context 'has @canonical set' do
      before(:each) { @canonical = '/my-address?with_query=string' }

      it 'generates canonical based on the @canonical instance variable' do
        expect(subject).to eq 'http://us.lvh.me/my-address'
      end
    end

    context 'bad URL' do
      let!(:request_double)  { double('Request', url: 'http://us.lvh.me/blah/vtha?a+|+b&c=d') }

      it 'should generate path' do
        expect(subject).to eq 'http://us.lvh.me/blah/vtha'
      end
    end
  end
end
