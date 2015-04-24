require 'spec_helper'

describe Spree::Taxon, :type => :model do
  describe '#seo_title' do
    context 'meta_title is blank' do
      let(:taxon) { create(:taxon, name: 'My Taxon Name', meta_title: '') }

      context 'taxon has a banner' do
        let(:banner) { create(:banner, title: 'Banner Title') }

        before(:each) do
          taxon.banner = banner
          taxon.save
        end

        it 'returns the taxon\'s banner title' do
          expect(taxon.seo_title).to eq('Banner Title')
        end
      end

      context 'taxon does not have a banner' do
        it 'returns the taxon\'s name' do
          expect(taxon.seo_title).to eq('My Taxon Name')
        end
      end
    end

    context 'meta_title is filled in' do
      let(:taxon) { create(:taxon, name: 'My Taxon Name', meta_title: 'Taxon Title') }

      it 'returns the meta_title' do
        expect(taxon.seo_title).to eq('Taxon Title')
      end
    end
  end
end
