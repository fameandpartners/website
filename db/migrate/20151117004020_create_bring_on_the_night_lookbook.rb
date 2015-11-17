class CreateBringOnTheNightLookbook < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/bring-on-the-night',
      :template_path => '/lookbook/show.html.slim',
      :variables => {"image_count"=>6, "lookbook"=>true, "limit"=>24}
    )
    page.translations.create!(:locale => 'en-US', :title => 'Bring on the Night', :meta_description => 'Bring on the Night', :heading => 'Bring on the Night')
    page.publish!
  end

  def down
    Revolution::Page.where(:path => '/lookbook/bring-on-the-night').delete_all
  end
end
