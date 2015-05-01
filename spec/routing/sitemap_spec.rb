require 'spec_helper'

describe 'Sitemap', type: :request do
  it_will :redirect, '/sitemap.xml', 'http://images.fameandpartners.com/sitemap/sitemap.xml.gz'
  it_will :redirect, '/sitemap.xml.gz', 'http://images.fameandpartners.com/sitemap/sitemap.xml.gz'
end
