class AddSpringRacingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/race-day',
      :template_path => '/lookbook/race_day.html.slim',
      :variables => {"limit"=>24}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Spring Racing', :meta_description => 'Spring Racing', :heading => 'Spring Racing')
  end

  def down
    Revolution::Page.where(:path => '/lookbook/race-day').delete_all
  end
end
