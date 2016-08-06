class CreateItGirlPage < ActiveRecord::Migration
  def up
    unless Revolution::Page.where(path: '/it-girl').exists?
      page = Revolution::Page.create!(
        path:          '/it-girl',
        template_path: '/lookbook/it_girl',
        variables:     { lookbook: true, limit: 9, pids: %w(1061-looking-glass 1068-white 1104-black 1105-black 1012-navy 1064-pale-blue 1092-pale-pink 1010-feather-love 1096-hot-pink) },
        publish_from:  1.day.ago
      )
      page.translations.create!(locale: 'en-US', title: "IT Girl", meta_description: "IT Girl", heading: "IT Girl", meta_description: "IT Girl")
      page.translations.create!(locale: 'en-AU', title: "IT Girl", meta_description: "IT Girl", heading: "IT Girl", meta_description: "IT Girl")
    end
  end

  def down
    Revolution::Page.where(path: '/it-girl').delete_all
  end
end
