require 'spec_helper'

describe 'Sitemap', type: :request do
  it_will :redirect, '/sitemap.xml', 'http://images.fameandpartners.com/sitemap/us.xml.gz'
  it_will :redirect, '/au/sitemap.xml', 'http://images.fameandpartners.com/sitemap/au.xml.gz'
  it_will :redirect, '/sitemap_index.xml.gz', 'http://images.fameandpartners.com/sitemap/sitemap.xml.gz'
end
