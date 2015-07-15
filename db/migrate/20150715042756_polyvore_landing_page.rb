class PolyvoreLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/garden-party',
      :template_path => '/lookbook/show.html.slim',
      :variables => {:image_count => 10, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Garden Party', :meta_description => 'Garden Party')
  end

  def down
    Revolution::Translation.where(:title => 'Garden Party').delete_all
    Revolution::Page.where(:path => '/lookbook/garden-party').delete_all
  end
end
