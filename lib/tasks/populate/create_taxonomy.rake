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
  Spree::Taxonomy.destroy_all
  Spree::Taxon.destroy_all
  Spree::Taxonomy.delete_all
  Spree::Taxon.delete_all
end

def build_taxonomy
  range_taxons_tree = {
    name: 'Range',
    permalink: 'range',
    childs: [
      'Full Range',
      'Long Dresses',
      'Short Dresses',
      'Skirts',
      'Tops'
    ]
  }
  style_taxons_tree = {
    name: 'Style',
    permalink: 'style',
    childs: [
      'Strapless',
      'Sweet heart',
      'One shoulder'
    ]
  }
  childs = range_taxons_tree.delete(:childs)
  create_taxonomy_node(range_taxons_tree, childs)

  childs = style_taxons_tree.delete(:childs)
  create_taxonomy_node(style_taxons_tree, childs)
end

def create_taxonomy_node(root_element_attributes, child_names)
  taxonomy = Spree::Taxonomy.where(name: root_element_attributes[:name]).first_or_create
  root_taxon = Spree::Taxon.where(root_element_attributes.merge(taxonomy_id: taxonomy.id)).first_or_create

  child_names.each do |name|
    child = Spree::Taxon.where(
      name: name,
      permalink: "#{root_taxon.permalink}/#{name.parameterize('_')}",
      taxonomy_id: taxonomy.id
    ).first_or_create
    child.move_to_child_of(root_taxon)
  end
end

def randomly_assign_taxons_to_products
  ranges = Spree::Taxon.roots.where(permalink: 'range').first.leaves
  styles = Spree::Taxon.roots.where(permalink: 'style').first.leaves

  Spree::Product.all.each do |product|
    product.taxons = [
      ranges[rand(ranges.size)],
      styles[rand(styles.size)]
    ]
  end
end
