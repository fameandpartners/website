class CreateWhiteTrendsPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/trends-white',
      template_path:    '/products/collections/show',
      pids:             %w().join(','),
      heading:          'White Trend',
      title:            'White Dresses, Tops, and Skirts',
      meta_description: 'Shop white dresses, white tops, and white skirts for summer 2017; all customizable and ethically made.',
      limit:            '99'
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids], banner_image_url: landing_page_properties[:banner_image_url] },
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
