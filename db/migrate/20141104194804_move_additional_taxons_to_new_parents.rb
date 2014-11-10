class MoveAdditionalTaxonsToNewParents < ActiveRecord::Migration
  def up
  	taxons_for_style =["Cape", "Cutout", "Embellishment", "Monochrome",
  											"Separates", "Split", "Two Tone"]

  	MoveAdditionalTaxonsToNewParents.move_to_taxonomy(taxons_for_style, "Style")
  end

  def down
  	# we don't need down
  end

  private

  def self.check_and_create(item_type, item_name)
  	si = item_type.where(name: item_name)
  	if si.count < 1
  		ni = item_type.new
  		ni.name = item_name
  		return ni
  	else
  		return si.first
  	end
  end

  def self.move_to_taxonomy(taxon_names, taxonomy_name)
  	taxonomy = Spree::Taxonomy.where(name: taxonomy_name).first
  	
  	taxon_names.each do |taxon_name|
  		
  		taxon = MoveAdditionalTaxonsToNewParents.check_and_create(Spree::Taxon, taxon_name)
  		
  		taxon.parent_id = taxonomy.root.id
      #must call set_permalink to regenerate the permalink with the new parent
      taxon.set_permalink
      taxon.taxonomy_id = taxon.parent.taxonomy_id
  		taxon.save
  	end
  end
end
