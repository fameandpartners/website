class AddVariantTaxon < ActiveRecord::Migration
  def change
    create_table :variant_taxons do |t|
      t.references :taxon
      t.references :product
      t.string :fabric_or_color

      t.timestamps
    end
  end
end
