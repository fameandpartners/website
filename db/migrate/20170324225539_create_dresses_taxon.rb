class CreateDressesTaxon < ActiveRecord::Migration
  def up
    if( Spree::Taxon.where(permalink: 'style/dress').empty? )
      taxon = Spree::Taxon.new( {permalink: 'style/dress', name: 'Dress', delivery_period: "7 - 10 business days" })
      taxon.parent = Spree::Taxon.find_by_permalink('style')
      taxon.taxonomy = Spree::Taxonomy.find_by_name('Style')
      taxon.save
      taxon.publish!
    end
    
  end

  def down
    Spree::Taxon.where(permalink: 'style/dress').first.destroy
  end
end
