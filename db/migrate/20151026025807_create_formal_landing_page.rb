class CreateFormalLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/formal-night',
      :template_path => '/lookbook/formal_night.html.slim',
      :variables => {"limit"=>24}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Formal Fever', :meta_description => 'Formal Fever', :heading => 'Formal Fever')

    formal_fever = Revolution::Page.where(:path => '/lookbook/formal-night').first_or_create
    formal_fever.template_path = '/lookbook/show.html.slim'
    formal_fever.variables = {:image_count=>2, :lookbook=>true, :limit=>99}
    formal_fever.translations.create!(:locale => 'en-US', :title => 'Formal Fever', :meta_description => 'Formal Fever', :heading => 'Formal Fever')
    formal_fever.save!
  end

  def down
    Revolution::Page.where(:path => '/formal-night').delete_all
  end
end
