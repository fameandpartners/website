class CreateDressesForPartiesLandingPage < ActiveRecord::Migration
  DRESS_FOR_PARTIES_PATH = '/dress-for-parties'.freeze

  def up
    unless Revolution::Page.where(path: DRESS_FOR_PARTIES_PATH).exists?
      page = Revolution::Page.create!(
        path:          DRESS_FOR_PARTIES_PATH,
        template_path: '/landing_pages/dress_for_parties',
        variables:     { lookbook: true, pids: %w(1054-ivory 283-white 262-white 345-white 1060-ivory 1049-ivory 1008-white 1009-ivory 1064-blush 1096-light-nude 1106-mushroom 635-peach 861-pale-grey 997-pale-blue 840-navy 582-navy
1037-champagne 1084-indigo-cotton-stripe 1087-navy 1067-pale-blue 987-grey 1018-black 1071-pale-blue 1056-looking-glass 980-burgundy 1092-black 643-black 1028-light-khaki 1095-black 485-black 640-forest-green 1046-black) },
        publish_from:  Date.current - 1.day
      )
      page.translations.create!(locale: 'en-US', title: "Dress for parties", heading: "Dress for parties", meta_description: "Discover beautiful party dresses here at Fame & Partners")
      page.translations.create!(locale: 'en-AU', title: "Dress for parties", heading: "Dress for parties", meta_description: "Discover beautiful party dresses here at Fame & Partners")
    end
  end

  def down
    Revolution::Page.where(path: DRESS_FOR_PARTIES_PATH).delete_all
  end
end
