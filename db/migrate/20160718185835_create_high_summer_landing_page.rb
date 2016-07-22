class CreateHighSummerLandingPage < ActiveRecord::Migration
  def up
    unless Revolution::Page.where(path: '/brittany-xavier-high-summer-collection').exists?
      page = Revolution::Page.create!(
        path:          '/brittany-xavier-high-summer-collection',
        template_path: '/landing_pages/high_summer',
        variables:     { lookbook: true, limit: 9, pids: %w(1090-white 1086-pale-blue-cotton-stripe 1082-navy 1071-pale-blue 1068-white 1061-looking-glass 1054-black 1040-black 1030-dark-burgundy) },
        publish_from:  1.day.ago
      )
      page.translations.create!(locale: 'en-US', title: "Britanny Xavier's High Summer Collection", meta_description: "Britanny Xavier's High Summer Collection", heading: "Britanny Xavier's High Summer Collection")
      page.translations.create!(locale: 'en-AU', title: "Britanny Xavier's High Summer Collection", meta_description: "Britanny Xavier's High Summer Collection", heading: "Britanny Xavier's High Summer Collection")
    end
  end

  def down
    Revolution::Page.where(path: '/brittany-xavier-high-summer-collection').delete_all
  end
end
