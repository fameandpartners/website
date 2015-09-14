class UpdateJacketsTaxonTaxonomyToOuterWear < ActiveRecord::Migration
  class Spree::Taxonomy < ActiveRecord::Base
  end

  def up
    if (jackets_taxonomy = Spree::Taxonomy.find_by_name('Jackets'))
      jackets_taxonomy.name = 'Outerwear'
      jackets_taxonomy.save

      jackets_taxon = jackets_taxonomy.root
      jackets_taxon.name = 'Outerwear'
      jackets_taxon.permalink = 'outerwear'
      jackets_taxon.publish!
      jackets_taxon.save
    end
  end

  def down
    if (outerwear_taxonomy = Spree::Taxonomy.find_by_name('Outerwear'))
      outerwear_taxonomy.name = 'Jackets'
      outerwear_taxonomy.save

      outerwear_taxon = outerwear_taxonomy.root
      outerwear_taxon.name = 'Jackets'
      outerwear_taxon.permalink = 'jackets'
      outerwear_taxon.save
    end
  end
end
