class CreateJacketsTaxonomy < ActiveRecord::Migration
  class Spree::Taxonomy < ActiveRecord::Base
  end

  class Revolution::Page < ActiveRecord::Base
  end

  def up
    # Taxonomy and Taxon
    jackets_taxonomy = Spree::Taxonomy.create(name: 'Jackets')
    jackets_taxon = jackets_taxonomy.root
    jackets_taxon.publish!

    # Pages
    jackets_page = Revolution::Page.new(path: '/jackets', template_path: '/products/collections/jackets.html.slim')
    jackets_page.save
    jackets_page.publish!
  end

  def down
    if jackets = Spree::Taxonomy.where(name: 'Jackets').first
      jackets.destroy
    end

    if jackets_page = Revolution::Page.where(path: '/jackets', template_path: '/products/collections/jackets.html.slim').first
      jackets_page.destroy
    end
  end
end
