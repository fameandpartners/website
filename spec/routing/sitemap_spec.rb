require 'spec_helper'

describe 'Sitemap', type: :request do

  before do
    rememoize(SiteVersion, :@default)
    create :site_version, :us, :default
    create :site_version, :au
  end

  it_will :redirect, 'http://us.fameandpartners.test/sitemap.xml', 'https://d1sd72h9dq237j.cloudfront.net/sitemap/us.xml.gz'
  it_will :redirect, 'http://au.fameandpartners.test/sitemap.xml', 'https://d1sd72h9dq237j.cloudfront.net/sitemap/au.xml.gz'
  it_will :redirect, '/sitemap_index.xml.gz', 'https://d1sd72h9dq237j.cloudfront.net/sitemap/sitemap.xml.gz'
end
