class CreateEveningShopUnder300Page < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/the-evening-shop/under-300',
      template_path:        '/products/collections/show',
      heading:              'Formal 2017 - Under $300',
      title:                'Gowns Under $300',
      meta_description:     'Ball gowns, evening dresses, and maxis under $300; completely customisable and ethically made-to-order.',
      banner_image_url:     'https://s3.amazonaws.com/fandp-web-production-marketing/the-evening-shop/1920-CategoryBanner-EveningGowns(249.jpg',
      curated:              'true',
      lookbook:             'true',
      pids:                 %w(706-black 915-black 916-black 1000-black 1285-black 1363-black 1371-navy 919-black 1325-navy 915-olive 1292-navy 1096-light-nude 1325-dark-nude 1349-dark-tan 1285-pretty-pink 916-dark-nude 1364-pretty-pink 1096-hot-pink 1363-white 915-pale-pink 1292-red 919-red 1364-red).join(',')
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
