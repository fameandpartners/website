class CreateSpringRacingCollectionLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/spring-racing-collection',
      template_path:    '/landing_pages/spring_racing_collection',
      pids:             %w(1043-navy 997-pale-blue 1037-taupe 1139-silver 1104-pale-pink 671-white 1056-looking-glass 1111-black 1054-black 1021-white 1053-black 1069-white 1110-rosewater-floral 1106-mushroom 1133-navy 1120-dusk 1091-pale-pink 1046-black 1078-indigo-cotton-stripe 1123-navy 1103-ornate-midnight-floral 1061-looking-glass 963-palermo-floral 1114-rosewater-floral 987-grey 640-black 1087-navy 1018-black).join(','),
      limit:            '99',
      heading:          'Spring Racing Collection',
      title:            'Dresses for Spring Racing Events',
      meta_description: 'Happy Spring Racing season! Get dressed up in customizable, made-to-order day dresses, cocktail dresses, jumpsuits, and matching sets for Derby Day, Girls\' Day Out, The Melbourne Cup, and beyond.',
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
