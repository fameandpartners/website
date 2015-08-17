class CreateJacketsTaxonomy < ActiveRecord::Migration
  class Spree::Taxonomy < ActiveRecord::Base
  end

  # Instead of being a good migration practice, declaring Revolution::Page on this migration
  # removes its acts_as_nested_set callbacks, raising errors on environments that cache classes
  # # class Revolution::Page < ActiveRecord::Base
  # # end

  def up
    # Taxonomy and Taxon
    jackets_taxonomy = Spree::Taxonomy.create(name: 'Jackets')
    jackets_taxon = jackets_taxonomy.root
    jackets_taxon.publish!

    # Pages
    jackets_page = Revolution::Page.create!(path: '/jackets', template_path: '/products/jackets/collection.html.slim')
    jackets_page.publish!
    jackets_page.translations.create!(locale: 'en-US', title: 'Jackets', meta_description: 'Jackets')
  end

  def down
    if jackets = Spree::Taxonomy.where(name: 'Jackets').first
      jackets.destroy
    end

    if jackets_page = Revolution::Page.where(path: '/jackets', template_path: '/products/jackets/collection.html.slim').first
      jackets_page.destroy
    end
  end
end
