require 'spec_helper'

describe 'Seo Helpers', type: :helper do
  include CommonHelper

  let(:au)                    { false }
  let(:current_site_version)  { double(SiteVersion, :is_australia? => au) }
  let(:request)               { double('Request', :url => 'http://fameandpartners.test/blah/vtha', :fullpath => '/blah/vtha') }

  before do
    allow(self).to receive(:get_host).and_return('fameandpartners.test')
  end

  describe '#get_href_lang' do
    let(:lang)     { :us }
    subject(:href) { get_hreflang(lang) }

    it 'generates default path' do
      expect(href).to eq 'http://fameandpartners.test/blah/vtha'
    end

    context 'homepage' do
      let(:request) { double('Request', :url => 'http://fameandpartners.test/', :fullpath => '/') }

      context 'australian site' do
        let(:lang) { :au }

        it 'generates path with trailing slash' do
          expect(href).to eq 'http://fameandpartners.test/au/'
        end
      end
    end

    context 'australian site' do
      let(:au) { true }

      context 'us lang' do
        it 'generates default path' do
          expect(href).to eq 'http://fameandpartners.test/blah/vtha'
        end
      end

      context 'au lang' do
        let(:lang) { :au }

        it 'generates au path' do
          expect(href).to eq 'http://fameandpartners.test/au/blah/vtha'
        end
      end
    end
  end

  describe '#get_canonical_href' do
    it 'should generate path' do
      expect(get_canonical_href).to eq 'http://fameandpartners.test/blah/vtha'
    end

    context 'product canonical' do
      let(:product) { double(Products::Presenter, :name => 'fancy-dress', :default_color => 'mauve') }

      before do
        @product = product
        allow(self).to receive(:collection_product_path).with(product).and_return("/#{product.name}")
      end

      it 'should generate canonical product path' do
        expect(get_canonical_href).to eq 'http://fameandpartners.test/fancy-dress'
      end

    end

    context 'has @canonical set' do
      before(:each) { @canonical = '/my-address?with_query=string' }

      it 'generates canonical based on the @canonical instance variable' do
        expect(get_canonical_href).to eq 'http://fameandpartners.test/my-address'
      end
    end
  end
end
