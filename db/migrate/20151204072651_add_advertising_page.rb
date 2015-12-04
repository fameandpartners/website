class AddAdvertisingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lp/1512/1',
      :template_path => '/landing_pages/advertising1.html.slim',
      :variables => {"limit"=>10 , "curated"=> true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Advertising 1', :meta_description => 'Advertising 1', :heading => 'Advertising 1')

    page = Revolution::Page.create!(
      :path => '/lp/1512/2',
      :template_path => '/landing_pages/advertising2.html.slim',
      :variables => {"limit"=>10 , "curated"=> true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Advertising 2', :meta_description => 'Advertising 2', :heading => 'Advertising 2')
  end

  def down
    Revolution::Page.where(:path => '/lp/1512/1').delete_all
    Revolution::Page.where(:path => '/lp/1512/2').delete_all
  end
end

