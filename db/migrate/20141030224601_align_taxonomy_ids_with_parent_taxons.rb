class AlignTaxonomyIdsWithParentTaxons < ActiveRecord::Migration
  def up
  	Spree::Taxon.all.each do |taxon|
  		if taxon.parent.present?
  			taxon.taxonomy_id = taxon.parent.taxonomy_id
  			taxon.save
  		end
  	end
  end

  def down
  end
end
