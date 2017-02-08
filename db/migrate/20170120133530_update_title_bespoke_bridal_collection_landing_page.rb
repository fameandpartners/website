class UpdateTitleBespokeBridalCollectionLandingPage < ActiveRecord::Migration
  private def landing_page_properties
    {
      path:             '/bespoke-bridal-collection',
      title:            'The Bespoke Bridal Collection'
    }
  end

  def up
    page = Revolution::Page.where(path: landing_page_properties[:path]).first
    page.translations.each do |p|
      p.title = landing_page_properties[:title]
      p.save!
    end
  end

end
