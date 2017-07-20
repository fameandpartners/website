class CreateFormal2017Page < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/formal-2017',
      template_path:        '/products/collections/show',
      heading:              'Formal',
      title:                'Formal Dresses',
      meta_description:     'Best dresses for 2017 formal and school balls.',
      banner_image_url:     '',
      curated:              'true',
      hide_pagination_link: 'true',
      limit:                '25',
      lookbook:             'true',
      pids:                 ''
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables: {
        banner_image_url: landing_page_properties[:banner_image_url],
        curated: landing_page_properties[:curated],
        hide_pagination_link: landing_page_properties[:hide_pagination_link],
        limit: landing_page_properties[:limit],
        lookbook: landing_page_properties[:lookbook],
        pids: landing_page_properties[:pids]
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
