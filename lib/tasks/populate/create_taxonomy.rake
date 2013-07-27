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
      ['Long Dresses', 'View our complete range of long dresses perfect for your next formal event.'],
      ['Short Dresses', 'View our complete range of short dresses, perfect for your next formal event.'],
      ['Skirts', 'View our complete range of skirts, mix and match with a top for something truly unique.'],
      ['Tops', 'View our complete range of tops, mix and match with a skirt for something truly unique.']
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
  root_taxon = Spree::Taxon.where(root_element_attributes.merge(taxonomy_id: taxonomy.id)).first_or_create

  childs_info.each do |name, description|
    child = Spree::Taxon.where(
      name: name,
      permalink: "#{root_taxon.permalink}/#{name.parameterize('_')}",
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
  ranges = Spree::Taxon.roots.where(permalink: 'range').first.leaves
  styles = Spree::Taxon.roots.where(permalink: 'style').first.leaves

  Spree::Product.all.each do |product|
    product.taxons = [
      ranges[rand(ranges.size)],
      styles[rand(styles.size)]
    ]
  end
end
