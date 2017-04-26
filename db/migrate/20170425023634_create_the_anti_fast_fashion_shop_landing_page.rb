class CreateTheAntiFastFashionShopLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/the-anti-fast-fashion-shop',
      template_path:    '/statics/landing_page_the_anti_fast_fashion_shop',
      pids:             %w().join(','),
      heading:          'The Anti-Fast Fashion Shop',
      title:            'Custom, ethically produced fashion',
      limit:            '99',
      meta_description: 'Individually customizable, ethically-produced clothing made-to-order on demand in under 2 weeks. This is Anti-Fast Fashion.',
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids] },
      publish_from:  1.day.ago
    )
    page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
    page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], meta_description: landing_page_properties[:meta_description])
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
