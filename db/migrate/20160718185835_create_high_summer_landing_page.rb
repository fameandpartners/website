class CreateHighSummerLandingPage < ActiveRecord::Migration
  def up
    unless Revolution::Page.where(path: '/brittany-xavier-high-summer-collection').exists?
      page = Revolution::Page.create!(
        path:          '/brittany-xavier-high-summer-collection',
        template_path: '/lookbook/style_icon/high_summer',
        variables:     { lookbook: true, limit: 9, pids: %w(1061-looking-glass 1068-white 1104-black 1105-black 1012-navy 1064-pale-blue 1092-pale-pink 1010-feather-love 1096-hot-pink) },
        publish_from:  1.day.ago
      )
      page.translations.create!(locale: 'en-US', title: "Brittany Xavier's High Summer Collection", meta_description: "Britanny Xavier's High Summer Collection", heading: "Britanny Xavier's High Summer Collection", meta_description: "Discover beautiful summer dresses here at Fame & Partners")
      page.translations.create!(locale: 'en-AU', title: "Brittany Xavier's High Summer Collection", meta_description: "Britanny Xavier's High Summer Collection", heading: "Britanny Xavier's High Summer Collection", meta_description: "Discover beautiful summer dresses here at Fame & Partners")
    end
  end

  def down
    Revolution::Page.where(path: '/brittany-xavier-high-summer-collection').delete_all
  end
end
