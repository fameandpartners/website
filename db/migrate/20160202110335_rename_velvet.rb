class RenameVelvet < ActiveRecord::Migration
  def up
    velvet_taxon = Spree::Taxon.where(name: "Velvets").first
    if velvet_taxon.present?
      velvet_taxon.name = "Velvet"
      velvet_taxon.save!
    end
  end

  def down
    velvet_taxon = Spree::Taxon.where(name: "Velvet").first
    if velvet_taxon.present?
      velvet_taxon.name = "Velvets"
      velvet_taxon.save!
    end
  end
end
