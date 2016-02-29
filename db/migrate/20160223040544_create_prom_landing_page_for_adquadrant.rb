class CreatePromLandingPageForAdquadrant < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
         :path => '/prom-ad',
         :template_path => '/landing_pages/prom-ad',
         :variables => {:image_count=>6, :lookbook => false, :limit => 28, :pids => ["902-black","915-pale-grey","931-black","918-ivory","934-ivory","922-navy","903-peach","897-dark-burgundy","910-mint","539-navy","905-ocean","906-aqua-lily","919-peach","910-icing-pink-and-red","899-grand-lily","938-pink-shimmer","632-black","923-magenta","908-bird-of-paradise","898-red","724-navy","901-dark-tan","97-black","928-midnight-reptile","449-pale-grey","680-light-pink","933-ivory","620-navy"] }
       )
    page.translations.create!(:locale => 'en-US', :title => 'PROM DRESSES', :meta_description => 'PROM DRESSES', :heading => 'PROM DRESSES')
    page.publish!
  end

  def down
    Revolution::Page.where(path: "/prom-ad").first.destroy
  end
end
