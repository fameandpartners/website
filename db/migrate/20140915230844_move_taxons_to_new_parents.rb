class MoveTaxonsToNewParents < ActiveRecord::Migration
  def up
  	taxonomies = %w(Event Style)

  	taxonomies.each do |taxonomy|
  		#we must call additional methods as class methods, otherwise 
  		#they are not visible to migration mechanisms
  		t = MoveTaxonsToNewParents.check_and_create(Spree::Taxonomy, taxonomy)
  		t.save
  	end

  	
  	taxons_for_event = ["Prom", "Weddings", "Formals", "Homecoming", "Balls", "Sweet 16", 
  											"Birthdays", "Debutante", "Graduation", "Special Events"]

  	taxons_for_style = ["A-Line", "Celebrity", "Cocktail", "Corset", "Empire Waist",
  											 "Halter", "High Lo", "Lace", "Long", "V-Neck", "Mermaid", 
  											 "Mesh", "Metallic", "Off Shoulder", "One Shoulder", "Open Back", 
  											 "Pastel", "Pleated", "Sequins", "Short", "Sleeves", "Sporty Luxe", 
  											 "Strapless", "Sweetheart", "Two Piece"]
  	
  	MoveTaxonsToNewParents.move_to_taxonomy(taxons_for_style, "Style")
  	MoveTaxonsToNewParents.move_to_taxonomy(taxons_for_event, "Event")
  end

  def down
  	# Range is old umbrella taxonomy
  	t = MoveTaxonsToNewParents.check_and_create(Spree::Taxonomy, "Range")
  	t.save

  	
  	taxons = Spree::Taxonomy.where(name: "Style").first.taxons.where('"spree_taxons"."parent_id" IS NOT NULL')
  	taxons_2 = Spree::Taxonomy.where(name: "Event").first.taxons.where('"spree_taxons"."parent_id" IS NOT NULL')

  	puts "total taxons"
  	puts taxons

  	puts "total taxons 2"
  	puts taxons_2

  	taxon_names = taxons.collect {|taxon| taxon.name}
  	puts "collected names:"
  	puts taxon_names

  	taxon_names_2 = taxons_2.collect {|taxon| taxon.name}
  	puts "collected names:"
  	puts taxon_names_2


  	MoveTaxonsToNewParents.move_to_taxonomy(taxon_names, "Range")
  	MoveTaxonsToNewParents.move_to_taxonomy(taxon_names_2, "Range")


  	# Return old taxons to Styles
  	old_taxons = ["Sweet Heart", "Strapless", "One Shoulder"]
  	MoveTaxonsToNewParents.move_to_taxonomy(old_taxons, "Style")

  	# Remove unused taxonomies
  	Spree::Taxonomy.where(name: "Event").first.delete
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
  	puts taxonomy_name
  	puts taxonomy
  	puts "Moving taxons into:"
  	puts taxonomy.name
  	puts taxonomy.id
  	taxon_names.each do |taxon_name|
  		puts "Moving:"
  		puts taxon_name
  		taxon = MoveTaxonsToNewParents.check_and_create(Spree::Taxon, taxon_name)
  		puts taxon
  		taxon.taxonomy_id = taxonomy.id
  		taxon.parent_id = taxonomy.root.id
  		taxon.save
  	end
  end
end
