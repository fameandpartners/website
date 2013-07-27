class Spree::TaxonBanner < ActiveRecord::Base
  set_table_name "spree_taxon_banners"

  belongs_to :taxon

  attr_accessible :title, :image, :description

  has_attached_file :image, styles: { banner: "746x180#" }
end
