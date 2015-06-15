require 'spec_helper'

describe Repositories::Taxonomy do
  let(:taxonomy) { create(:taxonomy, name: "My Taxonomy") }

  before(:each) { Repositories::Taxonomy.expire_cache!(true) }

  describe ".get_taxon_by_name" do
    describe 'find by name' do
      it 'case-insensitive' do
        taxon = create(:taxon, taxonomy_id: taxonomy.id, name: 'Great')

        result = described_class.get_taxon_by_name('gReAt')
        expect(result.id).to eq(taxon.id)
      end

      it 'find by non-hyphen name' do
        taxon = create(:taxon, taxonomy_id: taxonomy.id, name: 'World of something')

        result = described_class.get_taxon_by_name('World-of-something')
        expect(result.id).to eq(taxon.id)
      end
    end

    context 'it will return nil' do
      it 'taxon does not exist' do
        result = described_class.get_taxon_by_name('Nothing-To-See-Here')
        expect(result).to be_nil
      end

      it 'parameter is blank' do
        result = described_class.get_taxon_by_name('')
        expect(result).to be_nil
      end
    end
  end
end
