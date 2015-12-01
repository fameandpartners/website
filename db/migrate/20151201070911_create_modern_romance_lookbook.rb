class CreateModernRomanceLookbook < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/modern-romance',
      :template_path => '/lookbook/show.html.slim',
      :variables => {:image_count=>6, :lookbook => true, :limit => 24}
    )
    page.translations.create!(:locale => 'en-US', :title => 'Mordern Romance', :meta_description => 'Mordern Romance', :heading => 'Mordern Romance')
    page.publish!
  end

  def down
    Revolution::Page.where(:path => '/lookbook/modern-romance').delete_all
  end
end

