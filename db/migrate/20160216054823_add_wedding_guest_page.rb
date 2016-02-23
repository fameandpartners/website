class AddWeddingGuestPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
         :path => '/wedding-guest',
         :template_path => '/landing_pages/wedding-guest.html.slim',
         :variables => {:image_count=>6, :lookbook => false, :limit => 60, :pids => ["791-indigo","789-nautical-stripe","798-ice-blue","793-ice-grey","792-aqua","801-sage-fallen-leaves","806-teal","797-mint","810-lilac","572-surreal-floral-white","697-blush","631-burgundy","547-peach","724-navy","481-nude","494-brick","660-cherry-red","667-rosebud","515-light-pink","666-bright-lavender","537-ice-blue","670-apricot","635-peach","694-navy","794-ice-grey","717-chartreuse"] }
       )
    page.translations.create!(:locale => 'en-US', :title => 'Wedding Guest Dresses', :meta_description => 'Wedding Guest Dresses', :heading => 'Wedding Guest Dresses')
    page.publish!
  end

  def down
    Revolution::Page.where(path: "/wedding-guest").first.destroy
  end
end
