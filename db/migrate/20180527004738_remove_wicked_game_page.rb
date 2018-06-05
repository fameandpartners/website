class RemoveWickedGamePage < ActiveRecord::Migration
  def up
    Revolution::Page.where(:path => '/the-wicked-game').delete_all
  end
end
