class CreateEveningHoursCollectionLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/the-evening-hours-collection',
      template_path:    '/landing_pages/evening_hours_collection',
      pids:             %w('1202-cherry-red 1210-black 1216-black 1204-evening-bloom 1217-silver 1194-micro-star
1191-white 1197-indigo-cotton-stripe 1225-dark-forest 1201-black 1221-black 1222-silver 1190-ivory 1223-dark-forest 1098-black 1196-navy 1207-black 1214-navy 1225-black 1198-cherry-red 1218-black 1226-micro-spot 1228-dusk 1209-dark-forest 1189-cobalt-blue 1190-black 1187-evening-bloom 1203-dark-tan 1200-dark-teal 1206-black 1188-dark-tan 1224-black 1220-navy 1186-cobalt-blue 1212-black 1192-micro-star 1215-dark-tan 1199-burgundy 1227-dark-burgundy 1193-micro-spot 1228-black 1195-micro-star 1205-black 1219-dark-tan 1189-cherry-red 1213-black').join(','),
      limit:            '99',
      heading:          'The Evening Hours Collection',
      title:            'Easy, Effortless Cocktail Dresses',
      meta_description: 'Our cocktail collection is perfect for holiday parties: effortlessly chic minis, wraps, and slip dresses–all individually customizable & made-to-order.',
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
