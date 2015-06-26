class SalePage < ActiveRecord::Migration
  def up
      lookbook_template = '/lookbook/show.html.slim'

      page = Revolution::Page.create!(
        :path => '/dresses/sale',
        :template_path => lookbook_template,
        :variables => {:image_count => 1, :lookbook => true}
      )
      page.publish!
      page.translations.create!(:locale => 'en-US', :title => 'Sale', :meta_description => 'Dresses on Sale')
  end

  def down
    Revolution::Translation.where(:title => 'Sale').delete
    Revolution::Page.where(:path => '/dresses/sale').delete
  end
end
