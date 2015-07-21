class CreateLuxeCollection < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/the-luxe-collection',
      :template_path => '/lookbook/show.html.slim',
      :variables => {:image_count => 9, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'The Luxe Collection', :meta_description => 'The Luxe Collection')
  end

  def down
    Revolution::Translation.where(:title => 'The Luxe Collection').delete_all
    Revolution::Page.where(:path => '/lookbook/the-luxe-collection').delete_all
  end
end
