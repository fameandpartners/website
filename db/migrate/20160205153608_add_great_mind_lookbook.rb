class AddGreatMindLookbook < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/great-minds-think-alike',
      :template_path => '/lookbook/show.html.slim',
      :variables => {:image_count=>6, :lookbook => true, :limit => 24}
    )
    page.translations.create!(:locale => 'en-US', :title => 'Great Minds Think Alike', :meta_description => 'Great Minds Think Alike', :heading => 'Great Minds Think Alike')
    page.publish!
  end

  def down
    Revolution::Page.where(:path => '/lookbook/great-minds-think-alike').delete_all
  end
end
