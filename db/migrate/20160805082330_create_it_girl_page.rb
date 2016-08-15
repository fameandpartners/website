class CreateItGirlPage < ActiveRecord::Migration
  def up
    unless Revolution::Page.where(path: '/it-girl').exists?
      page = Revolution::Page.create!(
        path:          '/it-girl',
        template_path: '/lookbook/it_girl',
        variables:     { lookbook: 'true', limit: '99', pids: %w(1006-pale-pink 1118-black 1136-navy 1137-black 1039-ivory 1122-black 1041-warm-grey 1120-dusk 724-pale-pink 1110-rosewater-floral 1116-ivory 1109-champagne 1114-rosewater-floral 1046-ivory 1117-blush 1055-black 1070-black 1019-watercolour-camo 1085-white 971-red 1111-black 1104-pale-pink 646-black 1056-looking-glass 1093-sand 1073-white 1094-ornate-midnight-floral 993-black 1100-spot 1096-hot-pink 1103-ornate-midnight-floral 1102-mushroom 1091-pale-pink 1138-navy 1069-black 1047-ivory 1124-black 1092-black 1044-black 643-black) },
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
