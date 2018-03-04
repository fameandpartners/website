class CreateDianaVerasInterviewPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/diana-veras-interview',
      template_path:        '/landing_pages/prom_diana_veras_interview',
      heading:              'An Interview with Diana Veras',
      title:                'An Interview with Diana Veras',
      meta_description:     'Diana Veras on fashion, women’s empowerment, and her favorite evening gowns from Fame and Partners.',
      lookbook:             'true',
      pids:                 %w(1685-lilac-heavy-georgette 1198-navy-heavy-georgette 1652-navy-stretch-silk-charmeuse 1663-light-pink-duchess-satin).join(',')
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
