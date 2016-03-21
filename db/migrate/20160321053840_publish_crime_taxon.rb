class PublishCrimeTaxon < ActiveRecord::Migration
  def up
    tx = Spree::Taxon.where(name: 'Partners In Crime').first
    tx.publish! if tx.present?
  end

  def down
    tx = Spree::Taxon.where(name: 'Partners In Crime').first
    if tx.present?
      tx.publish = nil
      tx.save!
    end
  end
end
