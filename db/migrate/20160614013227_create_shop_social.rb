class CreateShopSocial < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/shop-social',
      :template_path => '/landing_pages/shop-social.html.slim'
    )

  page.translations.create!(:locale => 'en-US', :title => 'Shop instagram', :meta_description => 'Shop instagram', :heading => 'Shop instagram')
  page.publish!
  end

  def down
    Revolution::Page.where(:path => '/shop-social').delete_all
  end
end
