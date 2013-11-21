class AddSiteVersionToUser < ActiveRecord::Migration
  def self.up
    add_column :spree_users, :site_version_id, :integer
  end

  def self.down
    remove_column :spree_users, :site_version_id
  end
end
