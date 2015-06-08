class LookbookPages < ActiveRecord::Migration
  def up

    Revolution::Page.create!(:path => '/dresses/*', :template_path => '/product/collections/show.html.slim').publish!
    # '/landing_pages/here_comes_the_sun.html.slim'
    # '/lookbook/show.html.slim'
    lookbook_template = '/lookbook/show.html.slim'

    page = Revolution::Page.create!(
      :path => '/lookbook/here-comes-the-sun',
      :template_path => lookbook_template,
      :variables => {:image_count => 10, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Here Comes the Sun', :meta_description => 'Here Comes the Sun')

    page = Revolution::Page.create!(
      :path => '/lookbook/break-hearts',
      :template_path => lookbook_template,
      :variables => {:image_count => 9, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Break Hearts Not Bank Accounts', :meta_description => 'Break Hearts Not Bank Accounts')

    page = Revolution::Page.create!(
      :path => '/lookbook/bridesmaids',
      :template_path => lookbook_template,
      :variables => {:image_count => 10, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Bridesmaids and Besties', :meta_description => 'Bridesmaids & Besties')

    page = Revolution::Page.create!(
      :path => '/lookbook/all-size',
      :template_path => lookbook_template,
      :variables => {:image_count => 8, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'All Sizes', :meta_description => 'All Sizes')

    page = Revolution::Page.create!(
      :path => '/lookbook/prom',
      :template_path => lookbook_template,
      :variables => {:image_count => 10, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Prom', :meta_description => 'Prom')

    page = Revolution::Page.create!(
      :path => '/lookbook/bohemian-summer',
      :template_path => lookbook_template,
      :variables => {:image_count => 8, :lookbook => true}
    )
    page.publish!
    page.translations.create!(:locale => 'en-US', :title => 'Bohemian Summer', :meta_description => 'Bohemian Summer')
  end

  def down
    Revolution::Translation.delete_all
    Revolution::Page.delete_all
  end
end
