class AddCuration < ActiveRecord::Migration
  def change
    create_table :curations do |t|
      t.string :name
      t.string :pid
      t.integer :product_id
      t.boolean :active

      t.timestamps
    end
    add_index :curations, :product_id
    add_index :curations, :pid


    create_table :curations_taxons, :id => false do |t|
      t.integer :curation_id
      t.integer :taxon_id
    end
    add_index :curations_taxons, :curation_id

    VariantTaxon.all.each do |vt|
      product = vt.product

      c = Curation.find_or_create_by_pid("#{product.sku}~#{vt.fabric_or_color}")
      c.product = product
      c.taxons << vt.taxon
      c.save!
    end

    rename_table :variant_taxons, :old_variant_taxons
  end
end
