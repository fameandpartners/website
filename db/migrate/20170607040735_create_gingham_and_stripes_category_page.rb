class CreateGinghamAndStripesCategoryPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/trends-gingham-stripe',
      template_path:    '/products/collections/show',
      pids:             %w(1522-black-and-white-gingham 1538-pale-blue-and-white-pinstripe 1521-black-and-white-gingham 1482-black-and-white-gingham 1544-navy-and-white-gingham 1490-black-and-white-gingham 1546-navy-stripe 1517-navy-and-white-gingham 1484-black-and-white-gingham 1549-pale-blue-and-white-pinstripe 1487-black-and-white-gingham 1490-black-and-white-gingham 1387-pink-and-white-stripe 1338-black-and-white-gingham 1387-white-and-red-stripe 1367-pink-and-white-gingham).join(','),
      heading:          'Gingham and Stripes',
      title:            'Gingham and Pinstripe Dresses and Tops',
      meta_description: 'Gingham patterns and pinstripe prints for spring/summer, all customizable and ethically made.',
      banner_image_url: 'https://s3.amazonaws.com/fandp-web-production-marketing/lookbook/trends-gingham-stripe/banner-trends-gingham-stripe.jpg',
      limit:            '99'
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids], banner_image_url: landing_page_properties[:banner_image_url], banner_image_url: landing_page_properties[:banner_image_url] },
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
