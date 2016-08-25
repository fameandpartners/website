class CreateDressesForPartiesLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/dress-for-parties',
      template_path:    '/landing_pages/dress_for_parties',
      pids:             %w(1119-navy 1128-black 1136-navy 1127-black 1067-pale-blue 1077-navy 1061-looking-through-glass 1069-white 1138-navy 1112-rosewater-floral 1091-pale-pink 1030-dark-burgundy 1065-black 1123-champagne 1094-ornate-midnight-floral 1080-navy 1031-black 1042-pale-pink 1139-silver 1052-black 1124-black 1047-ivory 1043-navy 1048-ivory 980-burgundy 1092-black 643-black 1028-light-khaki 1053-black 485-black 640-forest-green 1046-black).join(','),
      heading:          'Dress for parties',
      title:            'Dress for parties',
      meta_description: 'Discover beautiful party dresses here at Fame & Partners',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true, pids: landing_page_properties[:pids] },
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
