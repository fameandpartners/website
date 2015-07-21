class CreateLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/mystyle',
      :template_path => '/pages/mystyle.html.slim',
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'My Style', :meta_description => 'My Style')
  end

  def down
    Revolution::Translation.where(:title => 'My Style').delete_all
    Revolution::Page.where(:path => '/mystyle').delete_all
  end
end
