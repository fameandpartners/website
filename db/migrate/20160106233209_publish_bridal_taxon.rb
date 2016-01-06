class PublishBridalTaxon < ActiveRecord::Migration
  def up
    Spree::Taxon.where(name: "Bridal").first.publish!
  end
end
