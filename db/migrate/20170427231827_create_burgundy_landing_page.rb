class CreateBurgundyLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/dresses/burgundy',
      template_path:    '/products/collections/show',
      pids:             %w(355-burgundy 933-burgundy 944-burgundy 968-burgundy 980-burgundy 1341-burgundy 1030-dark-burgundy 1227-dark-burgundy).join(','),
      heading:          'Burgundy',
      title:            'Burgundy Dresses',
      meta_description: 'Burgundy dresses and burgundy gowns, all customizable and ethically produced.',
      banner_image_url: 'https://s3.amazonaws.com/fandp-web-production-marketing/dresses/burgundy/banner_burgundy.jpg',
      limit:            '99'
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables:     { lookbook: true, curated: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids], banner_image_url: landing_page_properties[:banner_image_url] },
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
