class CreateBridesmaidsLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/landing/bridesmaids',
      :template_path => '/landing/bridesmaid.html.slim',
      :variables => {"limit"=>99}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Bridesmaids', :meta_description => 'Bridesmaids', :heading => 'Bridesmaids')
  end

  def down
    Revolution::Page.where(:path => '/landing/bridesmaids').delete_all
  end
end
