class CreateTaxonForWeddingProducts < ActiveRecord::Migration
  def add_products_to_guest_carousel
    taxon = Spree::Taxon.where(name: 'guest_carousel').first
    #TODO: UPDATE THIS LIST
    product_id_list = [670,575,515,674,666]
    if taxon.present?
      product_id_list.each do |id|
        p = Spree::Product.find_by_id(id)
        if p.present?
          p.taxons << taxon
        end
      end
    end
  end

  def add_products_to_bride_carousel
    taxon = Spree::Taxon.where(name: 'bride_carousel').first
    #TODO: UPDATE THIS LIST
    product_id_list = [345,262,185,474,517]
    if taxon.present?
      product_id_list.each do |id|
        p = Spree::Product.find_by_id(id)
        if p.present?
          p.taxons << taxon
        end
      end
    end
  end

  def add_products_to_bridesmaid_carousel
    taxon = Spree::Taxon.where(name: 'bridesmaid_carousel').first
    #TODO: UPDATE THIS LIST
    product_id_list = [672,444,441,697,97,607,570,414,185,430,493,445,340]
    if taxon.present?
      product_id_list.each do |id|
        p = Spree::Product.find_by_id(id)
        if p.present?
          p.taxons << taxon
        end
      end
    end
  end

  def up
    taxonomy_id = Spree::Taxonomy.where(name: 'Style').first.try(:id)
    parent_id   = Spree::Taxon.where(name: 'Style').first.try(:id)
    if taxonomy_id.present?
      tx              = Spree::Taxon.new
      tx.name         = 'guest_carousel'
      tx.taxonomy_id  = taxonomy_id
      tx.permalink    = 'style/guest_carousel'
      tx.published_at = Date.today
      tx.parent_id    = parent_id
      tx.save!

      tx              = Spree::Taxon.new
      tx.name         = 'bride_carousel'
      tx.taxonomy_id  = taxonomy_id
      tx.permalink    = 'style/bride_carousel'
      tx.published_at = Date.today
      tx.parent_id    = parent_id
      tx.save!

      tx              = Spree::Taxon.new
      tx.name         = 'bridesmaid_carousel'
      tx.taxonomy_id  = taxonomy_id
      tx.permalink    = 'style/bridesmaid_carousel'
      tx.published_at = Date.today
      tx.parent_id    = parent_id
      tx.save!
    end

    add_products_to_guest_carousel
    add_products_to_bride_carousel
    add_products_to_bridesmaid_carousel
  end

  def down
    Spree::Taxon.where(name: 'guest_carousel').first.destroy
    Spree::Taxon.where(name: 'bride_carousel').first.destroy
    Spree::Taxon.where(name: 'bridesmaid_carousel').first.destroy
  end
end
