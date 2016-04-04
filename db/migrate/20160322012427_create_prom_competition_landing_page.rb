class CreatePromCompetitionLandingPage < ActiveRecord::Migration
    def up
    page = Revolution::Page.create!(
      :path => '/partners-in-crime',
      :template_path => '/landing_pages/prom-competition',
      :variables => {"limit"=>24}
    )
    
    page.translations.create!(:locale => 'en-US', :title => 'Partners in crime', :meta_description => 'Partners in crime', :heading => 'Partners in crime')
    page.publish!
  end

  def down
    Revolution::Page.where(:path => '/partners-in-crime').delete_all
  end
end
