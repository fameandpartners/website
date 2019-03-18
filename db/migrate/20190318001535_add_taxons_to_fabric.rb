class AddTaxonsToFabric < ActiveRecord::Migration
  def change
    create_table :fabrics_taxons, :id => false do |t|
        t.references :fabric
        t.references :taxon
    end
    add_index :fabrics_taxons, [:fabric_id, :taxon_id]
    add_index :fabrics_taxons, :fabric_id
  end
end
