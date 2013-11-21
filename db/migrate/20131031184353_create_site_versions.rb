class CreateSiteVersions < ActiveRecord::Migration
  def up
    create_table :site_versions do |t|
      t.references :zone
      t.string :name
      t.string :permalink
      t.boolean :default, default: false
      t.boolean :active, default: false

      t.string :currency
      t.string :locale

      t.timestamps
    end

    add_index :site_versions, :zone_id
  end

  def down
    drop_table :site_versions
    remove_index :site_versions, :zone_id
  end
end
