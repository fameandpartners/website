class CreateBridesmaidsLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/famingtonway',
      :template_path => '/landing_pages/famingtonway.html.slim',
      :variables => {"limit"=>99}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Famingtonway', :meta_description => 'Famingtonway', :heading => 'Famingtonway')
  end

  def down
    Revolution::Page.where(:path => '/famingtonway').delete_all
  end
end
