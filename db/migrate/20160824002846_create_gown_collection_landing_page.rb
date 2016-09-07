class CreateGownCollectionLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/gown-collection',
      template_path:    '/landing_pages/gown_collection',
      pids:             %w(1127-ivory 1119-navy 1137-black 918-black 1130-black 1128-black 1099-pale-pink 1096-light-nude 944-tan 1136-navy 632-dark-gold 582-white 1118-black 1129-winter-grey 979-pale-pink 620-white 1111-black 919-black 915-black 897-cherry-red 1123-champagne 1121-navy 903-pale-blue 1110-rosewater-floral 1012-white 1120-dusk 379-navy 1000-black).join(','),
      limit:            '99',
      heading:          'Gown Collection',
      title:            'Gowns, ball gowns, and formal dresses',
      meta_description: 'Finding the perfect gown for a special occasion or formal event is easier than ever. Customize our gowns, ball gowns, floor length dresses, and formal two-piece sets to suit your size, height, and style for a look that’s unique to you.',
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
      page.translations.create!(locale: 'en-US', title: "#{landing_page_properties[:title]} | fameandpartners.com", heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
      page.translations.create!(locale: 'en-AU', title: "#{landing_page_properties[:title]} | fameandpartners.com.au", heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    end
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end


