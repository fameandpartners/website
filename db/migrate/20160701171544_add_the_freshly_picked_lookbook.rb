class AddTheFreshlyPickedLookbook < ActiveRecord::Migration
  def up
    if Revolution::Page.where(path: "/lookbook/the-freshly-picked-collection").first.nil?
      page = Revolution::Page.create!(
        :path => '/lookbook/the-freshly-picked-collection',
        :template_path => '/lookbook/show.html.slim',
        :variables => {:image_count=>5, :lookbook => true, :limit => 24}
      )
      page.translations.create!(:locale => 'en-US', :title => 'The Freshly Picked Collection', :meta_description => 'GThe Freshly Picked Collection', :heading => 'GThe Freshly Picked Collection')
      page.publish!
    end
  end

  def down
    Revolution::Page.where(:path => '/lookbook/the-freshly-picked-collection').delete_all
  end
end
