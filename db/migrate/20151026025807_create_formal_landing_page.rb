class CreateFormalLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/formal-night',
      :template_path => '/lookbook/formal_night.html.slim',
      :variables => {"limit"=>24}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Formal Fever', :meta_description => 'Formal Fever', :heading => 'Formal Fever')
  end

  def down
    Revolution::Page.where(:path => '/formal-night').delete_all
  end
end
