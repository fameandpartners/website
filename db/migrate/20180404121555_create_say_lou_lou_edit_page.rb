class CreateSayLouLouEditPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/evening-collection-say-lou-lou',
      template_path:        '/landing_pages/prom_say_lou_lou_edit',
      heading:              'Say Lou Lou’s Favorites',
      title:                'Say Lou Lou’s Favorites',
      meta_description:     'Shop Say Lou Lou’s favorite evening dresses and jumpsuits!',
      lookbook:             'true',
      # TO-DO: Add real PIDs
      pids:                 %w().join(',')
    }
  end

  def up

    # Remove the legacy page with this same URL (it's no longer used)
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all

    # Create the new page
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables: {
        lookbook: landing_page_properties[:lookbook],
        pids: landing_page_properties[:pids],
      },
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
