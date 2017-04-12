class CreateHighContrastLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/high-contrast',
      template_path:    '/products/collections/show',
      pids:             %w().join(','),
      heading:          'High Contrast',
      title:            'Red, Pink and Navy Styles',
      meta_description: 'Bold, high contrast styles in red, navy, and pink–all customizable and ethically made-to-order on demand.',
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables:     { lookbook: true, curated: true, pids: landing_page_properties[:pids] },
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
