class AddPublishedDatetimeToSpreeTaxons < ActiveRecord::Migration
  class Spree::Taxon < ActiveRecord::Base
  end

  def migrate_data
    taxons_on_header_menu = [
      # Events
      'formal',
      'wedding',
      'birthday',
      'special event',
      'ball gowns',
      'graduation',
      'prom',
      'homecoming',
      'sweet 16',
      'debutante',

      # Styles
      'plus size',
      'two piece',
      'one shoulder',
      'strapless',
      'v-neck',
      'split',
      'backless',
      'lace'
    ]

    taxons_on_header_menu.each do |taxon_name|
      if taxon = Spree::Taxon.where('name ILIKE ?', taxon_name).first
        taxon.published_at = Time.zone.now
        taxon.save
      end
    end
  end

  def up
    add_column :spree_taxons, :published_at, :datetime
    migrate_data
  end

  def down
    remove_column :spree_taxons, :published_at
  end
end
