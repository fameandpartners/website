class CreateDressesForWeadingsLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/dress-for-wedding',
      template_path:    '/landing_pages/dress_for_wedding',
      pids:             %w(1127-ivory 1054-ivory 1136-ivory 283-white 11060-ivory 1049-ivory 1008-white 1072-white 1064-blush 1096-light-nude 1106-mushroom 635-peach 861-pale-grey 997-pale-blue 840-navy 582-navy 1037-champagne 1084-indigo-cotton-stripe 1087-navy 1067-pale-blue 987-grey 1018-black 1071-pale-blue 1056-looking-glass).join(','),
      heading:          'Dress for weddings',
      title:            'Dress for weddings',
      meta_description: 'Discover beautiful wedding dresses here at Fame & Partners',
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
