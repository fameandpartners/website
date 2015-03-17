require 'spec_helper'

describe Repositories::Taxonomy do
  let(:taxonomy)    { create(:taxonomy, name: "My Taxonomy") }
  let(:root_taxon)  { create(:taxon, name: 'Root', permalink: 'my', taxonomy_id: taxonomy.id) }

  before(:each) { Repositories::Taxonomy.expire_cache!(true) }

  context "get_taxon_by_name" do
    it "find by name" do
      original = create(:taxon, parent_id: root_taxon.id, name: 'Great', permalink: 'my/great', taxonomy_id: taxonomy.id)

      taxon = Repositories::Taxonomy.get_taxon_by_name('great')
      expect(taxon).not_to be_nil
    end

    it "case-insensitive" do
      original = create(:taxon, parent_id: root_taxon.id, name: 'Great', permalink: 'my/GreaT', taxonomy_id: taxonomy.id)

      taxon = Repositories::Taxonomy.get_taxon_by_name('gReAt')
      expect(taxon).not_to be_nil
    end

    it "find by non-hyphen name" do
      original = create(:taxon, parent_id: root_taxon.id, name: 'World of something', permalink: 'my/world', taxonomy_id: taxonomy.id)

      taxon = Repositories::Taxonomy.get_taxon_by_name('World-of-something')
      expect(taxon).not_to be_nil
    end
  end
end
