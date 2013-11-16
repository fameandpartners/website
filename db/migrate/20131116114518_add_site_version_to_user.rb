class AddSiteVersionToUser < ActiveRecord::Migration
  def self.up
    add_column :spree_users, :site_version_id, :integer

    if SiteVersion.count > 0
      site_version = SiteVersion.default || SiteVersion.first
      Spree::User.update_all(site_version_id:  site_version.id)
    end
  end

  def self.down
    remove_column :spree_users, :site_version_id
  end
end
