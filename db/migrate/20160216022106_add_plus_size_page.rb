class AddPlusSizePage < ActiveRecord::Migration
  def up
      page = Revolution::Page.create!(
        :path => '/ad-plus-size',
        :template_path => '/landing_pages/ad_plus_size.html.slim',
        :variables => {:image_count=>6, :lookbook => false, :limit => 60, :pids => ["707-black", "607-lavender", "657-hot-pink", "670-apricot", "650-berry", "831-navy", "608-teal", "651-black", "563-berry", "831-silver", "561-deep-purple", "810-lilac", "676-cheetah", "678-rosebud", "554-hot-pink", "609-coral", "811-sage-fallen-leaves", "606-navy", "833-burgundy", "833-black", "658-teal", "838-burgundy", "836-white", "831-black", "837-black", "556-black", "836-silver", "659-cobalt-blue", "834-gold", "839-gunmetal", "832-grey", "834-gunmetal", "835-monochrome-coda", "565-light-blue"] }
      )
      page.translations.create!(:locale => 'en-US', :title => 'Plus Size Dresses', :meta_description => 'Plus Size Dresses', :heading => 'Plus Size Dresses')
      page.publish!
  end

  def down
    Revolution::Page.where(path: "/ad-plus-size").destroy!
  end
end
