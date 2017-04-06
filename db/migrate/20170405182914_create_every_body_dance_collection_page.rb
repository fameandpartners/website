class CreateEveryBodyDanceCollectionPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/every-body-dance',
      template_path:    '/products/collections/show',
      pids:             %w(1362-black 706-black 1338-black-and-white-gingham 1348-navy 1344-black 630-ivory 916-black 1336-navy 1336-pale-blue 1287-black 1348-dark-tan 916-pale-blue 1135-black 493-black 916-dark-nude 1367-pink-and-white-gingham 1375-black 1377-red 1369-black 1328-pretty-pink 1378-black 916-ivory 1341-burgundy 1358-black 968-burgundy 1370-navy 1356-black 1346-navy 1332-pale-pink 968-black 1363-black 1356-dark-tan 1377-pale-pink 1363-white 1329-black-and-white 909-black 1131-champagne 1346-dusty-rose 1286-navy 1330-black 1089-navy).join(','),
      heading:          '#everyBODYdance',
      title:            'Body-Positive Evening Dresses and Gowns',
      meta_description: 'Fame and Partners and Teen Vogue present #everyBODY dance: evening dresses created for all body types.',
    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true, curated: true, pids: landing_page_properties[:pids] },
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
