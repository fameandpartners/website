class CreateWholesalePage < ActiveRecord::Migration
  private def landing_page_properties
    {
      path:             '/wholesale',
      template_path:    '/statics/landing_page_wholesale',
      heading:          'Wholesale Inquiries',
      title:            'Wholesale Inquiries',
      meta_description: 'Bringing See-Now-Buy-Now into the wholesale space. The combination of cutting edge trend-tracking technology and our unique supply chain formula gives Fame and Partners the ability to deliver immediate, on-trend collections to market with unparalleled speed.'
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
