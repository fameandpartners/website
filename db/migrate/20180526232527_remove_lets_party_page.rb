class RemoveLetsPartyPage < ActiveRecord::Migration
  def up
    Revolution::Page.where(:path => '/lets-party').delete_all
  end
end
