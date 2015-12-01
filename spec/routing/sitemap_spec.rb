require 'spec_helper'

describe 'Sitemap', type: :request do

  before do
    rememoize(SiteVersion, :@default)
    create :site_version, :us, :default
    create :site_version, :au
  end

  it_will :redirect, 'http://us.fameandpartners.test/sitemap.xml', 'http://images.fameandpartners.com/sitemap/us.xml.gz'
  it_will :redirect, 'http://au.fameandpartners.test/sitemap.xml', 'http://images.fameandpartners.com/sitemap/au.xml.gz'
  it_will :redirect, '/sitemap_index.xml.gz', 'http://images.fameandpartners.com/sitemap/sitemap.xml.gz'
end
