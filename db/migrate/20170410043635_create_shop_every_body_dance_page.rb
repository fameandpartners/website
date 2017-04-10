class CreateShopEveryBodyDancePage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/shop-every-body-dance',
      template_path:    '/statics/landing_page_shop_every_body_dance',
      pids:             %w().join(','),
      heading:          '#everyBODYdance',
      title:            'Body-Positive Evening Dresses and Gowns',
      limit:            '99',
      meta_description: 'Fame and Partners and Teen Vogue present #everyBODY dance with Lauren Jauregui, Chloe Grace Moretz, Barbara Palvin and more.',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids] },
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
