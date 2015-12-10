class CreateBridalLandingPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/bridal-dresses',
      :template_path => '/landing_pages/bridal_dresses.html.slim',
      :variables => {
        "limit"=>99, 
        "pids"=>[
          "262-white", 
          "721-champagne", 
          "345-white", 
          "629-ivory", 
          "752-white", 
          "830-white", 
          "826-white", 
          "828-white", 
          "822-white", 
          "819-white", 
          "816-white", 
          "97-white", 
          "814-white", 
          "822-white", 
          "466-white", 
          "620-white", 
          "582-white", 
          "537-white", 
          "824-white", 
          "823-white", 
          "825-white", 
          "829-white", 
          "827-white", 
          "821-white", 
          "820-white", 
          "185-white", 
          "495-white", 
          "497-white", 
          "503-white", 
          "517-white", 
          "634-white", 
          "725-white", 
          "415-white", 
          "790-nude", 
          "414-white", 
          "474-white", 
          "522-white", 
          "817-white", 
          "579-ivory", 
          "481-nude", 
          "538-nude"
        ]
      }
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Bridal Dresses', :meta_description => 'Bridal Dresses', :heading => 'Bridal Dresses')
  end

  def down
    Revolution::Page.where(:path => '/bridal-dresses').delete_all
  end
end
