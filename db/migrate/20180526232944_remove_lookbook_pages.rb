class RemoveLookbookPages < ActiveRecord::Migration
  def up
    Revolution::Page.where(:path => '/lookbook/all-size').delete_all
    Revolution::Page.where(:path => '/lookbook/bohemian-summer').delete_all
    Revolution::Page.where(:path => '/lookbook/break-hearts').delete_all
    Revolution::Page.where(:path => '/lookbook/bring-on-the-night').delete_all
    Revolution::Page.where(:path => '/lookbook/dance-hall-days').delete_all
    Revolution::Page.where(:path => '/lookbook/formal-night').delete_all
    Revolution::Page.where(:path => '/lookbook/garden-wedding').delete_all
    Revolution::Page.where(:path => '/lookbook/here-comes-the-sun').delete_all
    Revolution::Page.where(:path => '/lookbook/jedi-cosplay').delete_all
    Revolution::Page.where(:path => '/lookbook/just-the-girls').delete_all
    Revolution::Page.where(:path => '/lookbook/la-belle-epoque').delete_all
    Revolution::Page.where(:path => '/lookbook/love-lace-collection').delete_all
    Revolution::Page.where(:path => '/lookbook/make-a-statement').delete_all
    Revolution::Page.where(:path => '/lookbook/partners-in-crime').delete_all
    Revolution::Page.where(:path => '/lookbook/photo-finish').delete_all
    Revolution::Page.where(:path => '/lookbook/race-day').delete_all
    Revolution::Page.where(:path => '/lookbook/sarah-ellen').delete_all
    Revolution::Page.where(:path => '/lookbook/the-luxe-collection').delete_all
    Revolution::Page.where(:path => '/lookbook/this-modern-romance').delete_all
    Revolution::Page.where(:path => '/partners-in-crime').delete_all
    Revolution::Page.where(:path => '/partners-in-crime-terms').delete_all
  end
end
