class CreateBespokeBridalSweepstakesLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/bespoke-bridal-sweepstakes',
      template_path:    '/landing_pages/bespoke_bridal_sweepstakes',
      heading:          'Win A Full Wedding Wardrobe',
      title:            'Win A Full Wedding Wardrobe',
      meta_description: 'Enter to win $5000 of bespoke, custom-made wedding dresses for the bride and her bridesmaids.',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true },
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
