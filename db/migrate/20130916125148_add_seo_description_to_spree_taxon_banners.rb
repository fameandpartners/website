class AddSeoDescriptionToSpreeTaxonBanners < ActiveRecord::Migration
  def change
    add_column :spree_taxon_banners, :seo_description, :text
  end
end
