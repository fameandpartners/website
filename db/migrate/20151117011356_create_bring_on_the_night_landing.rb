class CreateBringOnTheNightLanding < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/bring-on-the-night',
      :template_path => '/lookbook/bring-on-the-night.html.slim',
      :variables => {"limit"=>24}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Bring on the Night', :meta_description => 'Bring on the Night', :heading => 'Bring on the Night')
  end

  def down
    Revolution::Page.where(:path => '/bring-on-the-night').delete_all
  end
end
