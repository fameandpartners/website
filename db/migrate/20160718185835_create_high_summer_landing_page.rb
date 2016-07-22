class CreateHighSummerLandingPage < ActiveRecord::Migration
  def up
    if Revolution::Page.where(path: "/brittany-xavier-high-summer-collection").first.nil?
      page = Revolution::Page.create!(
        :path => '/brittany-xavier-high-summer-collection',
        :template_path => '/landing_pages/high_summer.html.slim',
        :variables => {:lookbook => true, :limit => 9, :pids => ["1090-white", "1086-pale-blue-cotton-stripe", "1082-navy", "1071-pale-blue", "1068-white", "1061-looking-glass", "1054-black", "1040-black", "1030-dark-burgundy"] }
      )
      page.translations.create!(:locale => 'en-US', :title => "Britanny Xavier's High Summer Collection", :meta_description => "Britanny Xavier's High Summer Collection", :heading => "Britanny Xavier's High Summer Collection")
      page.translations.create!(:locale => 'en-AU', :title => "Britanny Xavier's High Summer Collection", :meta_description => "Britanny Xavier's High Summer Collection", :heading => "Britanny Xavier's High Summer Collection")
      page.publish!
    end
  end

  def down
    Revolution::Page.where(:path => '/brittany-xavier-high-summer-collection').delete_all
  end
end
