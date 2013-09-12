namespace "db" do
  namespace "populate" do
    desc "create sea taxonomy"
    task :seo_taxonomy => :environment do
      create_seo_collection
    end
  end
end

def create_seo_collection
  name = "SeoCollection"
  permalink = "collection"

  taxonomy = Spree::Taxonomy.where("lower(name) = ?", name.downcase).first
  taxonomy ||= create_taxonomy(name, permalink)
end

def create_taxonomy(name, permalink)
  taxonomy = Spree::Taxonomy.new(name: name)
  taxonomy.position = Spree::Taxonomy.count.next
  taxonomy.save!

  root = taxonomy.root
  root.permalink = permalink
  root.save

  add_ball_gowns_taxon(taxonomy)
  add_plus_size_dresses_taxon(taxonomy)
end

def add_ball_gowns_taxon(taxonomy)
  args = {
    name: 'Ball Gowns',
    permalink: 'collection/Ball-Gowns',
    meta_title: 'Ball Gowns - Fame & Partners',
    meta_description: 'Fame & Partners stock a wide range of Ball Gowns online, visit our store today.'
  }
  add_child_taxon(taxonomy, args)
end

def add_plus_size_dresses_taxon(taxonomy)
  args = {
    name: 'Plus Size Dresses',
    permalink: 'collection/Plus-Size-Dresses',
    meta_title: 'Plus Size Dresses - Fame & Partners',
    meta_description: "Fame & Partners stock a wide range of plus size dresses online, visit our store today."
  }
  add_child_taxon(taxonomy, args)
end

def add_child_taxon(taxonomy, args)
  taxon = taxonomy.taxons.where("lower(name) = ? and lower(permalink) = ?", args[:name], args[:permalink]).first
  if taxon.blank?
    taxon = taxonomy.taxons.build(args)
  end
  taxon.save!
  taxon.move_to_child_of(taxonomy.root)
end
