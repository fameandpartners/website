class CreateShopEveryBodyDancePage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/shop-every-body-dance',
      template_path:    '/statics/landing_page_shop_every_body_dance',
      pids:             %w(1362-black 630-ivory 1348-navy 1287-black 1363-black 1285-black 1120-black 1356-black 1359-silver 1354-silver 1324-silver 1342-silver 1377-red 930-black 1332-pale-pink 1392-red 1340-black 1343-silver 1378-black 1345-warm-tan 968-black 1341-burgundy 1357-black 1370-navy).join(','),
      heading:          '#everyBODYdance',
      title:            'Body-Positive Evening Dresses and Gowns',
      limit:            '99',
      meta_description: 'Fame and Partners and Teen Vogue present #everyBODY dance with Lauren Jauregui, Ashley Moore, Nicolette Mason and more.',
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
