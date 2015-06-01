class LookbookPages < ActiveRecord::Migration
  def up

    Revolution::Page.create!(:path => '/dresses/*', :template_path => '/product/collections/show.html.slim').publish!
    # '/landing_pages/here_comes_the_sun.html.slim'
    # '/lookbook/show.html.slim'
    page = Revolution::Page.create!(:path => '/lookbook/here-comes-the-sun', :template_path => '/lookbook/here_comes_the_sun.html.slim')
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Here Comes the Sun', :meta_description => 'Here Comes the Sun')
  end

  def down
    Revolution::Translation.delete_all
    Revolution::Page.delete_all
  end
end
