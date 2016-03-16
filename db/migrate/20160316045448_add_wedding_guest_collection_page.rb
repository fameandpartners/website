class AddWeddingGuestCollectionPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
         :path => '/dresses/wedding-guests',
         :template_path => '/products/collections/show',
         :variables => {:image_count=>6, :lookbook => false, :limit => 99, :pids => ["680-light-pink", "724-navy", "923-dark-burgundy", "919-peach", "933-burgundy", "915-olive", "539-magenta", "840-baby-blue", "792-aqua", "911-aqua-lily", "793-ice-grey", "568-pink-and-blush", "547-peach", "97-navy", "914-cherry-red", "635-peach", "569-pastel-peach", "631-burgundy", "789-nautical-stripe"] }
       )
    page.translations.create!(:locale => 'en-US', :title => 'Wedding Guest Dresses', :meta_description => 'Wedding Guest Dresses', :heading => 'Wedding Guest Dresses')
    page.publish!
  end

  def down
    Revolution::Page.where(path: "/dresses/wedding-guests").first.destroy
  end
end
