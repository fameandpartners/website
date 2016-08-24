class CreateDressesForWeadingsLandingPage < ActiveRecord::Migration
  DRESS_FOR_WEDDING_PATH = '/dress-for-wedding'.freeze
  DRESS_FOR_WEDDING_PIDS = %w(1054-ivory 283-white 262-white 345-white 1060-ivory 1049-ivory 1008-white 1009-ivory 1064-blush 1096-light-nude 1106-mushroom 635-peach 861-pale-grey 997-pale-blue 840-navy 582-navy
1037-champagne 1084-indigo-cotton-stripe 1087-navy 1067-pale-blue 987-grey 1018-black 1071-pale-blue 1056-looking-glass 980-burgundy 1092-black 643-black 1028-light-khaki 1095-black 485-black 640-forest-green 1046-black).join(',').freeze

  def up
    unless Revolution::Page.where(path: DRESS_FOR_WEDDING_PATH).exists?
      page = Revolution::Page.create!(
        path:          DRESS_FOR_WEDDING_PATH,
        template_path: '/landing_pages/dress_for_wedding',
        variables:     { lookbook: true, pids: DRESS_FOR_WEDDING_PIDS },
        publish_from:  Date.current - 1.day
      )
      page.translations.create!(locale: 'en-US', title: "Dress for weddings", heading: "Dress for weddings", meta_description: "Discover beautiful wedding dresses here at Fame & Partners")
      page.translations.create!(locale: 'en-AU', title: "Dress for weddings", heading: "Dress for weddings", meta_description: "Discover beautiful wedding dresses here at Fame & Partners")
    end
  end

  def down
    Revolution::Page.where(path: DRESS_FOR_WEDDING_PATH).delete_all
  end
end
