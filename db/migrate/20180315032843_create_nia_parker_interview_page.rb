class CreateNiaParkerInterviewPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/nia-parker-interview',
      template_path:        '/landing_pages/prom_nia_parker_interview',
      heading:              'An Interview with Nia Parker',
      title:                'An Interview with Nia Parker',
      meta_description:     'Nia Parker on fashion, women’s empowerment, and her favorite evening gowns from Fame and Partners.',
      lookbook:             'true',
      pids:                 %w(1645-silver-metallic-woven-satin 1685-butterscotch-light-silk-charmeuse 1675-black-matte-satin 1683-black-spot-on-ivory-stretch-crepe).join(',')
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
        lookbook: landing_page_properties[:lookbook],
        pids: landing_page_properties[:pids],
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
