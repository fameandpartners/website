class DeleteCollectionBacklessTaxon < ActiveRecord::Migration
  def up
    Spree::Taxon.where(permalink: 'collection/backless').first.destroy
  end

  def down
  end
end
