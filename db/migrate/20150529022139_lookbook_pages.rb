class LookbookPages < ActiveRecord::Migration
  def up

    Revolution::Page.create!(:path => '/dresses/*', :template_path => '/product/collections/show.html.slim').publish!
    # '/landing_pages/here_comes_the_sun.html.slim'
    # '/lookbook/show.html.slim'
    lookbook_template = '/lookbook/show.html.slim'
    page = Revolution::Page.create!(
      :path => '/lookbook/here-comes-the-sun',
      :template_path => lookbook_template,
      :variables => {:image_count => 10, :lookbook => true}
    )

    page.publish!

    page.translations.create!(:locale => 'en-US', :title => 'Here Comes the Sun', :meta_description => 'Here Comes the Sun')
  end

  def down
    Revolution::Translation.delete_all
    Revolution::Page.delete_all
  end
end
