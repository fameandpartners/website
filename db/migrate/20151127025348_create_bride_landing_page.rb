class CreateBrideLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/brides',
      :template_path => '/landing_pages/brides.html.slim',
      :variables => {"limit"=>99}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Brides', :meta_description => 'Brides', :heading => 'Brides')
  end

  def down
    Revolution::Page.where(:path => '/brides').delete_all
  end
end
