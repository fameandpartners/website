class RenamePolyvoreLanding < ActiveRecord::Migration
  def up
    Revolution::Translation.where(:title => 'Garden Party').delete_all
    Revolution::Page.where(:path => '/lookbook/garden-party').delete_all

    page = Revolution::Page.create!(
      :path => '/lookbook/garden-wedding',
      :template_path => '/lookbook/show.html.slim',
      :variables => {:image_count => 10, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Garden Wedding', :meta_description => 'Garden Wedding')
  end

  def down
    Revolution::Translation.where(:title => 'Garden Wedding').delete_all
    Revolution::Page.where(:path => '/lookbook/garden-wedding').delete_all
  end
end
