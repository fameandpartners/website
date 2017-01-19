class CreateBespokeBridalCollectionLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/bespoke-bridal-collection',
      template_path:    '/landing_pages/bespoke_bridal_collection',
      heading:          'The Bespoke Bridal Collection',
      title:            'Evening Party Dresses',
      meta_description: 'Exclusive designs, exquisite laces, soft silks, and the perfect fit. Introducing our bespoke, made-to-order collection bridal dresses and wedding gowns.',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids], image_count: 7 },
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
