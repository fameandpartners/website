class CreatePromCompetitionLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/prom-competition',
      :template_path => '/landing_pages/prom-competition',
      :variables => {"limit"=>24}
    )
    
    page.translations.create!(:locale => 'en-US', :title => 'Prom Competition', :meta_description => 'Prom Competition', :heading => 'Prom Competition')
	page.publish!
  end

  def down
    Revolution::Page.where(:path => '/prom-competition').delete_all
  end
end
