class LookbookPages < ActiveRecord::Migration
  def up
    # lookbook = Revolution::Template.create!(:name => 'Lookbook', :custom => true, :data => '/lookbook/show.html.slim')
    lookbook = Revolution::Template.create!(:name => 'Lookbook', :custom => true, :data => '/landing_pages/here_comes_the_sun.html.slim')    

    collections = Revolution::Template.create!(:name => 'Collections', :custom => true, :data => '/product/collections/show.html.slim')

    Revolution::Page.create!(:path => '/dresses/*', :template => collections, :published => true)

    page = Revolution::Page.create!(:path => '/lookbook/here-comes-the-sun', :template => lookbook, :published => true)

    page.translations.create!(:locale => 'en-US', :title => 'Here Comes the Sun', :meta_description => 'Here Comes the Sun')
  end

  def down
    Revolution::Template.delete_all
    Revolution::Translation.delete_all
    Revolution::Page.delete_all
  end
end
