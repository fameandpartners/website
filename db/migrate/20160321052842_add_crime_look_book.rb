class AddCrimeLookBook < ActiveRecord::Migration
  def up
    if Revolution::Page.where(path: "/lookbook/partners-in-crime").first.nil?
      page = Revolution::Page.create!(
        :path => '/lookbook/partners-in-crime',
        :template_path => '/lookbook/show',
        :variables => {:image_count=>6, :lookbook => true, :limit => 24}
      )
      page.translations.create!(:locale => 'en-US', :title => 'Partners In Crime', :meta_description => 'Partners In Crime', :heading => 'Partners In Crime')
      page.publish!
    end
  end

  def down
    Revolution::Page.where(:path => '/lookbook/partners-in-crime').delete_all
  end
end
