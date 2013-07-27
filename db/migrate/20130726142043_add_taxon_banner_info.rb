class AddTaxonBannerInfo < ActiveRecord::Migration
  def change
    create_table :spree_taxon_banners, force: true do |t|
      t.references :spree_taxon

      t.string :title
      t.text :description

      t.string   :image_file_name
      t.string   :image_content_type
      t.integer  :image_file_size
      t.datetime :image_updated_at
    end
  end
end
