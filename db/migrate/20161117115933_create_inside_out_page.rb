class CreateInsideOutPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/inside-out',
      template_path:    '/landing_pages/inside_out',
      pids:             %w().join(','),
      limit:            '5',
      heading:          'Inside Out',
      title:            'Inside Out',
      meta_description: 'We believe fashion should empower you from the inside out. The INSIDE\OUT Collection celebrates this idea by donating $5 of each sale to UN Women and Plan International, and through the artwork of Dina Broadhurst.',
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
