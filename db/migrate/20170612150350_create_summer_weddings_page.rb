class CreateSummerWeddingsPage < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/dresses/summer-weddings',
      template_path:        '/products/collections/show',
      title:                'Summer Wedding Guest Dresses - Shop Online',
      heading:              'Summer Weddings',
      meta_description:     'The modern wedding dress code dictates stand-out style. Our Summer Weddings Collection features pieces that are special enough to work for every wedding on the calendar this season– and versatile enough to wear again and again.',
      banner_image_url:     'https://s3.amazonaws.com/fandp-web-production-marketing/lookbook/daywear/1920-categorybanner-springwedding.jpg',
      curated:              'true',
      hide_pagination_link: 'true',
      limit:                '53',
      lookbook:             'true',
      pids:                 %w(1493-navy 1530-oasis-floral 1539-pale-blue 1550-mixed-bouquet-floral 1529-black-and-white-spot 1114-rosewater-floral 1539-navy 1494-black-and-white-spot 1387-pink-and-white-stripe 1346-navy 1380-dark-tan 1353-dusty-rose 1113-pale-blue 1061-looking-glass 1369-black 1230-black 1223-dark-forest 1361-pretty-pink 1106-mushroom 1275-ornate-dusk-floral 1345-warm-tan 1203-dark-tan 1370-navy 640-forest-green 1384-navy-and-pretty-pink 1293-silver 1276-navy 1378-black 1214-navy 1346-dusty-rose 1392-red 1390-navy-and-red 1341-burgundy 1386-navy-and-pretty-pink 1278-red 1344-black 1327-black 1371-navy 1202-red 1064-red 1060-azure 1106-red 1354-silver 1113-pale-blue 1282-black 1350-pale-pink 1090-navy 1355-candy-floral 1111-black 1360-dark-tan 1278-black 1366-champagne 1294-black 1064-blush 1255-black 1108-black 1349-dark-tan 1326-dark-tan 1277-black 1232-black).join(',')
    }
  end

  def up
    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables: {
        banner_image_url: landing_page_properties[:banner_image_url],
        curated: landing_page_properties[:curated],
        hide_pagination_link: landing_page_properties[:hide_pagination_link],
        limit: landing_page_properties[:limit],
        lookbook: landing_page_properties[:lookbook],
        pids: landing_page_properties[:pids]
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
