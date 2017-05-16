class CreateWhiteTrendsPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/trends-white',
      template_path:    '/products/collections/show',
      pids:             %w(766-white 815-white 1076-white 1080-white 1079-white 1077-white 1083-white 1085-white 1087-white 1088-white 1090-white 1141-white 1143-white 1149-white 1155-white 1168-white 1191-white 1170-white 1247-white 1435-white 1263-white 1438-white 1440-white 1441-white 1445-white 1457-white 1464-white 1466-white 1467-white 1476-white 1480-white 1488-white 1500-white).join(','),
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
