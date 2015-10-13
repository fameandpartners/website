class CreateDanceHallDaysLookbook < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/dance-hall-days',
      :template_path => '/lookbook/dance_hall_days.html.slim',
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Dance Hall Days', :meta_description => 'Dance Hall Days')
  end

  def down
    Revolution::Translation.where(:title => 'Dance Hall Days').delete_all
    Revolution::Page.where(:path => '/lookbook/dance-hall-days').delete_all
  end
end
