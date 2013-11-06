class CreateSiteVersions < ActiveRecord::Migration
  def create_default_site_versions
    australia = Spree::Zone.where(name: 'australia').first
    version = SiteVersion.create(
      permalink: 'au',
      name: 'australia',
      zone_id: australia.try(:id),
      currency: 'AUD',
      locale: 'en_AU',
      default: true
    )

    usa = Spree::Zone.where(name: 'USA').first
    version = SiteVersion.create(
      permalink: 'us',
      name: 'usa',
      zone_id: usa.try(:id),
      currency: 'USD',
      locale: 'en_US',
      default: false
    )
  end

  def change
    create_table :site_versions, force: true do |t|
      t.references :zone
      t.string :name
      t.string :permalink
      t.boolean :default, default: false
      t.boolean :active, default: false

      t.string :currency
      t.string :locale

      t.timestamps
    end

    create_default_site_versions

    add_index :site_versions, :zone_id
  end
end
