class CreateMacysLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/macys',
      :template_path => '/landing_pages/macys.html.slim'
    )
    
  page.translations.create!(:locale => 'en-US', :title => 'Macys', :meta_description => 'Macys', :heading => 'Macys')
  page.publish!
  end

  def down
    Revolution::Page.where(:path => '/macys').delete_all
  end
end
