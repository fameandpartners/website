class CreateSummerBbqCategoryPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/casual-summer-styles',
      template_path:        '/products/collections/show',
      heading:              'Summer Styles',
      title:                'Summer party dresses and separates',
      meta_description:     'Casual day dresses and laid-back separates for your next summer party or BBQ, all customizable and sustainably produced.',
      banner_image_url:     'https://s3.amazonaws.com/fandp-web-production-marketing/casual-summer-styles/summer-bbq-page-banner.jpg',
      curated:              'true',
      hide_pagination_link: 'true',
      limit:                '25',
      lookbook:             'true',
      pids:                 %w(1383-white-and-red-stripe 1389-red 1543-white 1491-pale-blue 1482-black-and-white-gingham 1549-pale-blue-and-white-pinstripe 1387-pink-and-white-stripe 1517-navy-and-white-gingham 1547-red 1536-white 1538-pale-blue-and-white-pinstripe 1526-pretty-pink 1523-white 1522-black-and-white-gingham 1454-pretty-pink 1528-navy 1522-black-and-white-gingham 1466-white 1449-white-and-black-pinstripe 1435-white 1456-navy-stripe 1453-white-and-black-pinstripe 1478-pale-blue 1501-pretty-pink 1500-white).join(',')
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
