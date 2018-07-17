class CreateMicroFloralCategoryPage < ActiveRecord::Migration
# All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/shop-micro-floral',
      template_path:        '/products/collections/show',
      heading:              'Micro Floral Dresses & Jumpsuits',
      title:                'Custom-Made Micro Floral Dresses & Jumpsuits',
      meta_description:     'Shop micro floral dresses and micro floral jumpsuits, all customizable and ethically made-to-order.',
      curated:              'true',
      lookbook:             'true',
      pids:                 %w(1738-black-stretch-crepe 1737-midnight-navy-matte-satin 1730-black-heavy-georgette 1719-black-heavy-stretch-linen 1733-dainty-floral-light-georgette 1732-riviera-micro-floral-heavy-georgette 1715-ice-grey-linen 1736-pale-blue-light-georgette 1730-cornflower-blue-heavy-georgette 1735-midnight-paradise-matte-satin 1718-sesame-heavy-stretch-linen 1734-ivory-heavy-georgette 1730-ivory-raised-spot-georgette 1722-ivory-cotton-poplin-stripe 1712-ivory-linen 1720-ivory-heavy-stretch-linen 1443-ivory-medium-silk-charmeuse 1671-ivory-raised-spot-georgette 1690-ivory-raised-spot-georgette 1707-black-light-silk-charmeuse 1691-black-poly-stretch-suiting 1586-black-and-tan-spot 1485-black-and-white-spot 1683-black-spot-on-ivory-stretch-crepe 1484-black-and-white-gingham 1525-oasis-floral 1674-como-floral-light-georgette 1708-olive-sandwashed-silk).join(',')
    }
  end

  def up

    # Remove any legacy page with this same URL to avoid conflicts
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all

    page = Revolution::Page.create!(
      path:          landing_page_properties[:path],
      template_path: landing_page_properties[:template_path],
      variables: {
        curated: landing_page_properties[:curated],
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
