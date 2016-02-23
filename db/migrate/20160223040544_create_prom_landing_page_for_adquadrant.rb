class CreatePromLandingPageForAdquadrant < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
         :path => '/prom-ad',
         :template_path => '/landing_pages/prom-ad.html.slim',
         :variables => {:image_count=>6, :lookbook => false, :limit => 60, :pids => [] }
       )
    page.translations.create!(:locale => 'en-US', :title => 'PROM DRESSES', :meta_description => 'PROM DRESSES', :heading => 'PROM DRESSES')
    page.publish!
  end

  def down
    Revolution::Page.where(path: "/prom-ad").first.destroy
  end
end
