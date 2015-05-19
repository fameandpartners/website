require 'spec_helper'

describe LocalizeUrlService do
  describe '.localize_url' do
    before(:each) do
      SiteVersion.instance_variable_set(:@permalinks, nil) # Invalidating memoization
      create(:site_version, permalink: 'pt')
    end

    describe 'given a URL and a site version' do
      context 'URL does not have a locale in it' do
        let(:url) { 'http://example.com/something' }
        let(:site_version) { build_stubbed(:site_version, permalink: 'fr') }

        it 'prepends the site version permalink into the URL' do
          result = described_class.localize_url(url, site_version)
          expect(result).to eq('http://example.com/fr/something')
        end
      end

      context 'request has an existent locale in its url' do
        let(:url) { 'http://example.com/pt/something' }
        let(:site_version) { create(:site_version, permalink: 'fr') }

        it 'removes site versions from the request full path' do
          result = described_class.localize_url(url, site_version)
          expect(result).to eq('http://example.com/fr/something')
        end
      end

      context 'site version is the default' do
        let(:url) { 'http://example.com/something' }
        let(:site_version) { build_stubbed(:site_version, default: true) }

        it 'only uses the request fullpath' do
          result = described_class.localize_url(url, site_version)
          expect(result).to eq('http://example.com/something')
        end
      end
    end
  end
end
