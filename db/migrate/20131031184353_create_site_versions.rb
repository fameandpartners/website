class CreateSiteVersions < ActiveRecord::Migration
  def create_default_site_versions
    australia = Spree::Zone.all.detect{ |zone| zone.name.downcase.eql?('australia') }
    SiteVersion.create(
      permalink: 'au',
      name: 'australia',
      zone_id: australia.try(:id),
      currency: 'AUD',
      locale: 'en-AU',
      default: true
    )

    usa = Spree::Zone.all.detect{ |zone| zone.name.downcase.eql?('usa') }
    usa = Spree::Zone.create(name: 'USA', description: 'USA') unless usa.present?
    SiteVersion.create(
      permalink: 'us',
      name: 'usa',
      zone_id: usa.try(:id),
      currency: 'USD',
      locale: 'en-US',
      default: false
    )
  end

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

    create_default_site_versions

    add_index :site_versions, :zone_id
  end

  def down
    drop_table :site_versions
    remove_index :site_versions, :zone_id
  end
end
