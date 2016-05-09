class CreateStylingSessionPlusSizeLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/styling-session-plus',
      :template_path => '/landing_pages/styling_session_plus.html.slim'
    )
    
  page.translations.create!(:locale => 'en-US', :title => 'Personal styling session', :meta_description => 'Personal styling session with your very own stylist.', :heading => 'Personal styling session with your very own stylist.')
  page.publish!
  end

  def down
    Revolution::Page.where(:path => '/styling-session-plus').delete_all
  end
end
