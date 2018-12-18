class CreateBestOfFameCollection < ActiveRecord::Migration
  # All values MUST be Strings!
  private def landing_page_properties
    {
      path:                   '/best-of-fame',
      template_path:          '/products/collections/show',
      pids:                   %w(1135-black 1285-pretty-pink 944-dark-tan 1120-black 632-navy 1285-black 1120-dusk 1096-light-nude 1109-champagne 919-black 680-forest-green).join(','),
      heading:                'Best of Fame',
      subheading:             '<div class="item text-left"><div class="item-copy"><h4 class="itemTitle h1 no-margin">Five days <br><em>or less.</em></h4><p class="summary"><em>Listen,</em> we\'re really good at handcrafting these best selling-styles. It\'ll take us less than 5 days to make and ship your order.</p></div></div>',
      title:                  'Best Selling Party Dresses',
      meta_description:       'Need it now? We\'ll handcraft and deliver these made-to-order evening styles in under five days.',
      show_info_box:          true,
      section_box_class_name: 'category-text-box--black-bg',
      banner_image_url:       'https://d2ta5pga3sqz6i.cloudfront.net/pages/best-of-fame/banner.jpg'

    }
  end

  def up
    unless Revolution::Page.where(path: landing_page_properties[:path]).exists?
      page = Revolution::Page.create!(
        path:          landing_page_properties[:path],
        template_path: landing_page_properties[:template_path],
        variables:     { lookbook: true, limit: landing_page_properties[:limit], pids: landing_page_properties[:pids], 'show-collection-info-box': landing_page_properties[:show_info_box], 'section-box-class-name': landing_page_properties[:section_box_class_name], banner_image_url: landing_page_properties[:banner_image_url] },
        publish_from:  1.day.ago
      )
      page.translations.create!(locale: 'en-US', title: landing_page_properties[:title], heading: landing_page_properties[:heading], sub_heading: landing_page_properties[:subheading], meta_description: landing_page_properties[:meta_description])
      page.translations.create!(locale: 'en-AU', title: landing_page_properties[:title], heading: landing_page_properties[:heading], sub_heading: landing_page_properties[:subheading], meta_description: landing_page_properties[:meta_description])
    end
  end

  def down
    Revolution::Page.where(path: landing_page_properties[:path]).delete_all
  end
end
