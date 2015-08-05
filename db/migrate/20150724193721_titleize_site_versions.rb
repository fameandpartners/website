class TitleizeSiteVersions < ActiveRecord::Migration
  class SiteVersion < ActiveRecord::Base
  end

  def up
    SiteVersion.find_each do |site_version|
      site_version.name = site_version.name == 'usa' ? 'USA' : site_version.name.titleize
      site_version.save
    end
  end

  def down
    SiteVersion.find_each do |site_version|
      site_version.name = site_version.name.downcase
      site_version.save
    end
  end
end
