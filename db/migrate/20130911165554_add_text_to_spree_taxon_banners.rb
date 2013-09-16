class AddTextToSpreeTaxonBanners < ActiveRecord::Migration
  def change
    add_column :spree_taxon_banners, :footer_text, :text
  end
end
