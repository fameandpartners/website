class MergeBridemaidsTaxon < ActiveRecord::Migration
  def up
    dressses = Spree::Taxon.find(217).products
    event_bridesmaid_taxon = Spree::Taxon.find(221)
    dressses.each do |d|
      if d.taxons.none?{|t| t.id == 221 }
        d.taxons << event_bridesmaid_taxon
        d.save!
      end
    end
    Spree::Taxon.find(217).delete
  end
end
