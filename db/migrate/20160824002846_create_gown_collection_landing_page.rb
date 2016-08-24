class CreateGownCollectionLandingPage < ActiveRecord::Migration
  def up
    unless Revolution::Page.where(path: '/gown-collection').exists?
      page = Revolution::Page.create!(
        path:          '/gown-collection',
        template_path: '/landing_pages/gown_collection',
        variables:     { lookbook: 'true', limit: '99' },
        publish_from:  1.day.ago
      )
      page.translations.create!(locale: 'en-US', title: "The Gown Collection", meta_description: "Classic silhouettes, your way. Our gowns are all customizable and made-to-order.", heading: "The Gown Collection", meta_description: "Classic silhouettes, your way. Our gowns are all customizable and made-to-order.")
      page.translations.create!(locale: 'en-AU', title: "The Gown Collection", meta_description: "Classic silhouettes, your way. Our gowns are all customizable and made-to-order.", heading: "The Gown Collection", meta_description: "Classic silhouettes, your way. Our gowns are all customizable and made-to-order.")
    end
  end

  def down
    Revolution::Page.where(path: '/gown-collection').delete_all
  end
end
