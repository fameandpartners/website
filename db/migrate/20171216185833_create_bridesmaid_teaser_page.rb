class CreateBridesmaidTeaserPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/coming-soon-custom-bridesmaid-dresses',
      template_path:        '/statics/landing_page_bridesmaid_teaser',
      heading:              'Custom Bridesmaid Dresses',
      title:                'Custom Bridesmaid Dresses',
      meta_description:     'Coming Soon: Custom and Color Like No Other, with 500,000,000 ways to customize your bridesmaid dresses.',
      lookbook:             'true'
    }
  end

  def up

    # Remove the legacy page with this same URL (it's no longer used)
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all

    # Create the new page
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables: {
        lookbook: landing_page_properties[:lookbook]
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