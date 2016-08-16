class RenameTaxonsForNewInterimNav < ActiveRecord::Migration
  # Taxons being renamed. Remember, these will have 301
  # `/dresses/wedding` -> `/dresses/bridal`
  # `/dresses/short` -> `/dresses/mini`

  def up
    wedding_taxon = Spree::Taxon.published.find_child_taxons_by_permalink('wedding')
    wedding_page  = Revolution::Page.find_for('/dresses/wedding')

    short_taxon = Spree::Taxon.published.find_child_taxons_by_permalink('short')
    short_page  = Revolution::Page.find_for('/dresses/short')

    # Yes, this has duplicated logic. Quick dirty migration. No need for decoupling here.

    # Wedding
    if wedding_page && wedding_taxon
      # Rename taxon
      wedding_taxon.name      = 'Bridal'
      wedding_taxon.permalink = ''
      wedding_taxon.set_permalink
      wedding_taxon.save

      # Create new page
      wedding_new_page      = wedding_page.dup
      wedding_new_page.path = '/dresses/bridal'
      wedding_new_page.save
      wedding_page.translations.each do |translation|
        wedding_new_page.translations << translation.dup
      end
    end

    # Short
    if short_page && short_taxon
      # Rename taxon
      short_taxon.name      = 'Mini'
      short_taxon.permalink = ''
      short_taxon.set_permalink
      short_taxon.save

      # Create new page
      short_new_page      = short_page.dup
      short_new_page.path = '/dresses/mini'
      short_new_page.save
      short_page.translations.each do |translation|
        short_new_page.translations << translation.dup
      end
    end
  end

  def down
    # NOOP. data migration
  end
end
