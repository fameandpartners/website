namespace "db" do
  namespace "populate" do
    desc "create default taxonomy"
    task :taxonomy => :environment do
      clear_taxonomy
      build_taxonomy
      randomly_assign_taxons_to_products
    end
  end
end

def clear_taxonomy
  Spree::Taxonomy.delete_all
  Spree::Taxon.delete_all
  Spree::Taxonomy.destroy_all
  Spree::Taxon.destroy_all
  Spree::Product.all.each {|p| p.taxons = []; p.save }
end

def build_taxonomy
  range_taxons_tree = {
    name: 'Range',
    permalink: 'collection',
    title: 'Full Range',
    description: 'Fame & Partners formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.',
    childs: [
      ['Long Dresses', 'View our complete range of long dresses perfect for your next formal event.'],
      ['Short Dresses', 'View our complete range of short dresses, perfect for your next formal event.'],
      ['Skirts', 'View our complete range of skirts, mix and match with a top for something truly unique.'],
      ['Tops', 'View our complete range of tops, mix and match with a skirt for something truly unique.'],
      ['Prom Dresses', 'View our complete range of tops, mix and match with a skirt for something truly unique.']
    ]
  }
  style_taxons_tree = {
    name: 'Style',
    permalink: 'style',
    childs: [
      ['Strapless', ''],
      ['Sweet heart',''],
      ['One shoulder', '']
    ]
  }
  childs = range_taxons_tree.delete(:childs)
  create_taxonomy_node(range_taxons_tree, childs)

  childs = style_taxons_tree.delete(:childs)
  create_taxonomy_node(style_taxons_tree, childs)
end

def create_taxonomy_node(root_element_attributes, childs_info)
  taxonomy = Spree::Taxonomy.where(name: root_element_attributes[:name]).first_or_create
  root_taxon = taxonomy.root || Spree::Taxon.where(root_element_attributes.merge(taxonomy_id: taxonomy.id)).first_or_create
  root_taxon.update_attribute(:permalink, root_element_attributes[:permalink])

  if root_element_attributes[:description].present? || root_element_attributes[:title].present?
    banner = root_taxon.build_banner(
      description: root_element_attributes[:description],
      title: root_element_attributes[:title]
    )
    banner.save
  end

  childs_info.each do |name, description|
    child = Spree::Taxon.where(
      name: name,
      permalink: "#{root_element_attributes[:permalink]}/#{name.parameterize}",
      taxonomy_id: taxonomy.id
    ).first_or_create

    if description.present?
      banner = child.build_banner(description: description, title: name)
      banner.save
    end

    child.move_to_child_of(root_taxon)
  end
end

def randomly_assign_taxons_to_products
  collections = Spree::Taxon.roots.where(permalink: 'collection').first.leaves
  styles = Spree::Taxon.roots.where(permalink: 'style').first.leaves

  Spree::Product.all.each do |product|
    product.taxons = [
      collections[rand(collections.size)],
      collections[rand(collections.size)],
      styles[rand(styles.size)]
    ].uniq
  end
end
