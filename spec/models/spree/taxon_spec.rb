require 'spec_helper'

describe Spree::Taxon, :type => :model do
  describe 'scopes' do
    describe '.published' do
      let!(:unpublished_taxon) { create(:taxon, published_at: 2.days.from_now) }
      let!(:published_taxon)   { create(:taxon, published_at: 1.day.ago) }

      it 'returns published taxons' do
        result = described_class.published
        expect(result).to match([published_taxon])
      end
    end

    describe '.from_taxonomy' do
      context 'given a taxonomy name' do
        let!(:material_taxonomy) { create(:taxonomy, name: 'Clothes') }
        let!(:material_taxon)    { material_taxonomy.root }
        let!(:jeans_taxon)       { create(:taxon, taxonomy: material_taxonomy, name: 'Jeans') }
        let!(:yoyo_taxon)        { create(:taxon, name: 'Yoyo') }

        it 'it returns taxons from the taxonomy' do
          result = described_class.from_taxonomy('Clothes')
          expect(result).to match([jeans_taxon, material_taxon])
        end
      end
    end
  end

  describe '.find_child_taxons_by_permalink' do
    describe 'given a permalink string' do
      let!(:parent) { create(:taxon, name: 'Parent') }
      let!(:child)  { create(:taxon, parent_id: parent.id, name: 'Child') }

      it 'finds taxons with parents' do
        result = described_class.find_child_taxons_by_permalink('child')
        expect(result).to eq(child)
      end

      it 'does not find root taxons' do
        result = described_class.find_child_taxons_by_permalink('parent')
        expect(result).to be_nil
      end
    end
  end

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
