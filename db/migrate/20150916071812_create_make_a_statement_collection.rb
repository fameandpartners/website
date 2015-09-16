class CreateMakeAStatementCollection < ActiveRecord::Migration
  def up
    page = Revolution::Page.create!(
      :path => '/lookbook/make-a-statement',
      :template_path => '/lookbook/show.html.slim',
      :variables => {:image_count => 9, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Make A Statement', :meta_description => 'Make A Statement')
  end

  def down
    Revolution::Translation.where(:title => 'Make A Statement').delete_all
    Revolution::Page.where(:path => '/lookbook/make-a-statement').delete_all
  end
end
