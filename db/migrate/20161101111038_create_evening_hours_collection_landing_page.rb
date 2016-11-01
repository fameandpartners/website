class CreateEveningHoursCollectionLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/the-evening-hours-collection',
      template_path:    '/landing_pages/evening_hours_collection',
      pids:             %w().join(','),
      limit:            '99',
      heading:          'The Evening Hours Collection',
      title:            'Easy, Effortless Cocktail Dresses',
      meta_description: 'Our cocktail collection is perfect for holiday parties: effortlessly chic minis, wraps, and slip dresses–all individually customizable & made-to-order.',
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
