class CreateCocktailCollectionLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/cocktail-collection',
      template_path:    '/landing_pages/cocktail_collection',
      pids:             %w(1041-warm-grey 1043-navy 1039-pale-grey 1139-silver 720-white 1104-pale-pink 646-black 1111-black 1055-ivory 1050-ivory 1048-ivory 1069-white 1028-light-khaki 931-black 956-black 1120-dusk 11099-pale-pink 1128-blush 942-black 1123-navy 1052-black 1092-pale-pink 656-white 1114-rosewater-floral 1054-black 766-black 1047-black 1018-black).join(','),
      limit:            '99',
      heading:          'Cocktail Collection',
      title:            'Cocktail dresses, bodycon dresses, lace dresses',
      meta_description: 'May we freshen your cocktail dress? Upgrade your evening wardrobe with customizable, unique cocktail dresses and jumpsuits, including luxe lace, bodycon silhouettes, floral prints, and off-the-shoulder details.',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids] },
        publish_from:  1.day.ago
      )
      page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
      page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    end
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
