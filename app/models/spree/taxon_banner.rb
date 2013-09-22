class Spree::TaxonBanner < ActiveRecord::Base
  self.table_name = "spree_taxon_banners"

  belongs_to :taxon

  attr_accessible :title, :image, :description, :footer_text, :seo_description

  has_attached_file :image, styles: { banner: "746x180#" }
end
