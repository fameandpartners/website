require 'spec_helper'

describe 'Sitemap', type: :request do
  @asset_host = ENV['RAILS_ASSET_HOST']

  before do
    create :site_version, :us, :default
    create :site_version, :au
  end

  it_will :redirect, 'http://us.fameandpartners.test/sitemap.xml', "#{@asset_host}/sitemap/us.xml.gz"
  it_will :redirect, 'http://au.fameandpartners.test/sitemap.xml', "#{@asset_host}/sitemap/au.xml.gz"
end
