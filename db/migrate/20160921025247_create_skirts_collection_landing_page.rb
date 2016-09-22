class CreateSkirtsCollectionLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/skirts-collection',
      template_path:    '/landing_pages/skirts_collection',
      pids:             %w().join(','),
      limit:            '99',
      heading:          'Skirts Collection',
      title:            'Skirts, mini skirts, and maxi skirts',
      meta_description: 'Introducing The Skirts Collection. It’s never been easier to find the perfect skirt–from pencil skirts to midi skirts, from office-appropriate skirts to sequined party skirts; each piece in the collection is uniquely customizable and made-to-order, just for you.',
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
