class CreateDelilahBelleHamlinInterviewPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/delilah-belle-hamlin-interview',
      template_path:        '/landing_pages/prom_delilah_belle_hamlin_interview',
      heading:              'An Interview with Delilah Belle Hamlin',
      title:                'An Interview with Delilah Belle Hamlin',
      meta_description:     'Delilah Belle Hamlin on fashion, women’s empowerment, and her favorite evening gowns from Fame and Partners.',
      lookbook:             'true',
      pids:                 %w(1659-navy-heavy-georgette 1676-light-nude-soft-tulle 1679-red-light-georgette 1678-pale-blue-heavy-georgette).join(',')
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
