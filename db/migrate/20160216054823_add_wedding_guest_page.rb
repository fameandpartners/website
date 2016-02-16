class AddWeddingGuestPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
         :path => '/wedding-guest',
         :template_path => '/landing_pages/wedding-guest.html.slim',
         :variables => {:image_count=>6, :lookbook => false, :limit => 60, :pids => [] }
       )
    page.translations.create!(:locale => 'en-US', :title => 'Wedding Guest Dresses', :meta_description => 'Wedding Guest Dresses', :heading => 'Wedding Guest Dresses')
    page.publish!
  end

  def down
    Revolution::Page.where(path: "/wedding-guest").destroy!
  end
end
