class CreateHolidayCollectionLandingPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:             '/holiday-collection',
      template_path:    '/landing_pages/holiday_collection',
      pids:             %w(1162-black 1181-dark-tan 1158-black 1164-olive 1161-black 1156-black 1176-hot-pink 1182-black 1143-white 1146-pale-grey 1178-dark-nude 1174-black 1144-navy 1148-black 1167-black 1173-ivory 1175-chambray 1155-white 1169-black 1165-black 740-ivory 1154-olive 1173-ivory 1159-black 1142-art-soul 1166-navy 1171-spot 1179-black 1152-navy 1168-white 1150-pale-blue-cotton-stripe 1149-white 1149-white 1145-ochre 1163-chambray 1151-navy 1177-pale-pink 1153-watercolour-camo 1147-red 1172-olive).join(','),
      limit:            '99',
      heading:          'Holiday Collection',
      title:            'Holiday Collection',
      meta_description: 'Holiday Collection',
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
