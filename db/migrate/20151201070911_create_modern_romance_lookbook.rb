class CreateModernRomanceLookbook < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/this-modern-romance',
      :template_path => '/lookbook/show.html.slim',
      :variables => {:image_count=>6, :lookbook => true, :limit => 24}
    )
    page.translations.create!(:locale => 'en-US', :title => 'This Mordern Romance', :meta_description => 'This Mordern Romance', :heading => 'This Mordern Romance')
    page.publish!
  end

  def down
    Revolution::Page.where(:path => '/lookbook/this-modern-romance').delete_all
  end
end

