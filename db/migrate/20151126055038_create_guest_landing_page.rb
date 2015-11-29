class CreateGuestLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/guest',
      :template_path => '/landing_pages/guest.html.slim',
      :variables => {"limit"=>99}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Guest', :meta_description => 'Guest', :heading => 'Guest')
  end

  def down
    Revolution::Page.where(:path => '/guest').delete_all
  end
end
