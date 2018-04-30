class CreateWeddingsPartiesSllPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/weddings-parties-say-lou-lou',
      template_path:        '/landing_pages/prom_say_lou_lou_edit',
      heading:              'Say Lou Lou’s Favorites',
      title:                'Say Lou Lou’s Favorites',
      meta_description:     'Shop Say Lou Lou’s favorite evening dresses and jumpsuits!',
      lookbook:             'true',
      pids:                 %w(1292-black-heavy-georgette 1292-navy-heavy-georgette 1109-spring-posey-heavy-georgette 1670-spring-posey-light-georgette 1704-lilac-light-silk-charmeuse 1704-black-light-silk-charmeuse 1695-pale-blue-heavy-georgette 1706-black-sandwashed-silk 1655-blue-grey-light-silk-charmeuse 1655-pretty-pink-heavy-georgette 1364-pretty-pink-heavy-georgette 1705-dark-mint-light-silk-charmeuse 1443-ivory-medium-silk-charmeuse 1708-olive-sandwashed-silk).join(',')
    }
  end

  def up

    # Remove the legacy page with this same URL (it's no longer used)
    Revolution::Page.where(path: '/evening-collection-say-lou-lou').delete_all

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

    # Create the original page again
    page = Revolution::Page.create!(
      path:          '/evening-collection-say-lou-lou',
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
end
