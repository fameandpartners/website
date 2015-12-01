class AddDomainToSiteVersions < ActiveRecord::Migration
  class SiteVersion < ActiveRecord::Base
  end

  def up
    add_column :site_versions, :domain, :string, default: '', null: false
    associate_domains_to_site_versions
  end

  def down
    remove_column :site_versions, :domain
  end

  def associate_domains_to_site_versions
    if (australia = SiteVersion.where(permalink: 'au').first)
      australia.update_column(:domain, 'www.fameandpartners.com.au')
    end

    if (usa = SiteVersion.where(permalink: 'us').first)
      usa.update_column(:domain, 'www.fameandpartners.com')
    end
  end
end
