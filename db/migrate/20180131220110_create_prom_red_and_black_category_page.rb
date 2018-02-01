class CreatePromRedAndBlackCategoryPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/prom-red-and-black',
      template_path:        '/products/collections/show',
      heading:              'Shop Red and Black',
      title:                'Red and Black Prom Dresses',
      meta_description:     'Featuring red and black dress styles for prom.',
      banner_image_url:     'https://s3.amazonaws.com/fandp-web-production-marketing/category-banners/prom-red-black-bg.jpg',
      curated:              'true',
      lookbook:             'true',
      pids:                 %w(1135-black 1292-red 1362-black 1364-red 1363-black 1351-red 1341-burgundy 1344-black 919-red 1120-black 1369-black 1198-red 1127-black 1064-red 944-burgundy 1356-black 1202-red 438-black 1494-black 1339-red 1118-black 1618-red).join(',')
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
