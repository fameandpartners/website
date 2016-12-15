class CreatePreRegisterBridesmaidSweepstakesPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/pre-register-bridesmaid',
      template_path:    '/statics/pre_register_bridesmaid_sweepstakes',
      heading:          'Pre-register Bridesmaid Sweepstakes',
      title:            'Custom Bridesmaid Dresses',
      meta_description: 'Pre-register for the Wedding Atelier App and design your own custom, cohesive, beautiful bridesmaid dresses. Enter to win a wedding wardrobe for the entire bridal party!',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
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
