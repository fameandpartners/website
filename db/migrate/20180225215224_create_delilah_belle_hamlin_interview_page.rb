class CreateDelilahBelleHamlinInterviewPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/delilah-belle-hamlin-interview',
      template_path:        '/landing_pages/prom_delilah_belle_hamlin_interview',
      heading:              'Delilah Belle Hamlin Interview',
      title:                'Delilah Belle Hamlin Interview',
      meta_description:     '[TO-DO] Add real meta description',
      lookbook:             'true',
      # TO-DO: enter real PIDs
      pids:                 %w(684-black 709-black 942-black 1082-white).join(',')
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
