require 'spec_helper'

describe 'Sitemap', type: :request, memoization_support: true do

  before do
    rememoize(SiteVersion, :@default)
    create :site_version, :us, :default
    create :site_version, :au
  end

  it_will :redirect, '/sitemap.xml', 'http://images.fameandpartners.com/sitemap/us.xml.gz'
  it_will :redirect, '/au/sitemap.xml', 'http://images.fameandpartners.com/sitemap/au.xml.gz'
  it_will :redirect, '/sitemap_index.xml.gz', 'http://images.fameandpartners.com/sitemap/sitemap.xml.gz'
end
