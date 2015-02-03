require 'spec_helper'

describe Repositories::Taxonomy do
  let(:taxonomy) { create(:taxonomy, name: "My Taxonomy") }

  context "get_taxon_by_name" do
    it "find by name" do
      original = create(:taxon, name: 'Great', permalink: 'my/great')

      taxon = Repositories::Taxonomy.get_taxon_by_name('great')
      expect(taxon).not_to be_nil
    end

    it "case-insensitive" do
      original = create(:taxon, name: 'Great', permalink: 'my/GreaT')

      taxon = Repositories::Taxonomy.get_taxon_by_name('gReAt')
      expect(taxon).not_to be_nil
    end

    it "find by non-hyphen name" do
      original = create(:taxon, name: 'World of something', permalink: 'my/world')

      taxon = Repositories::Taxonomy.get_taxon_by_name('World-of-something')
      expect(taxon).not_to be_nil
    end
  end
end
