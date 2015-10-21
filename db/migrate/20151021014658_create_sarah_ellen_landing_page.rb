class CreateSarahEllenLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/sarah-ellen',
      :template_path => '/lookbook/sarah_ellen.html.slim',
      :variables => {"limit"=>24}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Sarah Ellen - Dance Hall Days', :meta_description => 'Sarah Ellen - Dance Hall Days', :heading => 'The exclusive Miss. Ellen')

    dance_hall = Revolution::Page.where(:path => '/lookbook/dance-hall-days').first
    dance_hall.template_path = '/lookbook/show.html.slim'
    dance_hall.variables = {:image_count=>2, :lookbook=>true, :limit=>99}
    dance_hall.save!
  end

  def down
    Revolution::Page.where(:path => '/sarah-ellen').delete_all
  end
end
