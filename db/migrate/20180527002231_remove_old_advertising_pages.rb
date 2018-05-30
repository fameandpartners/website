class RemoveOldAdvertisingPages < ActiveRecord::Migration
  def up
    Revolution::Page.where(:path => '/lp/1512/1').delete_all
    Revolution::Page.where(:path => '/lp/1512/2').delete_all
    Revolution::Page.where(:path => '/lp/1512/3').delete_all
    Revolution::Page.where(:path => '/lp/1512/4').delete_all
  end
end
