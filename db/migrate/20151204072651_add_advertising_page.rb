class AddAdvertisingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lp/1512/1',
      :template_path => '/landing_pages/advertising1.html.slim',
      :variables => {"limit"=>10 , "curated"=> true},
      :noindex => true
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Advertising 1', :meta_description => 'Advertising 1', :heading => 'Advertising 1')

    page = Revolution::Page.create!(
      :path => '/lp/1512/2',
      :template_path => '/landing_pages/advertising2.html.slim',
      :variables => {"limit"=>10 , "curated"=> true},
      :noindex => true
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Advertising 2', :meta_description => 'Advertising 2', :heading => 'Advertising 2')

    page = Revolution::Page.create!(
      :path => '/lp/1512/3',
      :template_path => '/landing_pages/advertising3.html.slim',
      :variables => {"limit"=>10 , "curated"=> true},
      :noindex => true
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Advertising 3', :meta_description => 'Advertising 3', :heading => 'Advertising 3')

    page = Revolution::Page.create!(
      :path => '/lp/1512/4',
      :template_path => '/landing_pages/advertising4.html.slim',
      :variables => {"limit"=>10 , "curated"=> true},
      :noindex => true
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Advertising 4', :meta_description => 'Advertising 4', :heading => 'Advertising 4')
  end

  def down
    Revolution::Page.where(:path => '/lp/1512/1').delete_all
    Revolution::Page.where(:path => '/lp/1512/2').delete_all
    Revolution::Page.where(:path => '/lp/1512/3').delete_all
    Revolution::Page.where(:path => '/lp/1512/4').delete_all
  end
end

