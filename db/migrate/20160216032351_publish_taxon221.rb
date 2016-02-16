class PublishTaxon221 < ActiveRecord::Migration
  def up
    Spree::Taxon.where(permalink: "event/bridesmaid").first.publish!
  end
end
