class CreateLarsenThompsonInterviewPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/larsen-thompson-interview',
      template_path:        '/landing_pages/prom_larsen_thompson_interview',
      heading:              'An Interview with Larsen Thompson',
      title:                'An Interview with Larsen Thompson',
      meta_description:     'Larsen Thompson on dance, women’s empowerment, and her favorite evening gowns from Fame and Partners.',
      lookbook:             'true',
      pids:                 %w(1675-black-matte-satin 905-pale-blue-heavy-georgette 1664-teal-heavy-silk-charmeuse 1288-red-pearl-chiffon).join(',')
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
