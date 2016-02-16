class PublishTaxon221 < ActiveRecord::Migration
  def up
    Spree::Taxon.find(221).publish!
  end
end
