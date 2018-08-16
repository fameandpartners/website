class CreatePolkaDotCategoryPage < ActiveRecord::Migration
# All values MUST be Strings!
  private def landing_page_properties
    {
      path:                 '/shop-polka-dot',
      template_path:        '/products/collections/show',
      heading:              'Polka Dot Dresses & Jumpsuits',
      title:                'Customize to Polka Dot',
      meta_description:     'Shop polka dot dresses and linen jumpsuits, all customizable and ethically made-to-order.',
      curated:              'true',
      lookbook:             'true',
      pids:                 %w(1721-ivory-cotton-poplin-stripe 1716-ivory-heavy-stretch-linen 1729-ivory-raised-spot-georgette 1720-ivory-heavy-stretch-linen 1479-dark-nude 1724-sesame-heavy-stretch-linen 1718-sesame-heavy-stretch-linen 1715-ice-grey-linen 1714-blue-violet-linen 1713-blue-violet-linen 1479-black 1724-black-stretch-crepe 1729-black-heavy-georgette 1719-black-heavy-stretch-linen 1739-navy-cotton-sateen 1714-black-linen 1729-red-heavy-georgette 1729-red-heavy-georgette 1729-lemon-heavy-georgette).join(',')
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
