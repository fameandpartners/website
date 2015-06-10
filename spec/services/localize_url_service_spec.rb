require 'spec_helper'

describe LocalizeUrlService do
  before(:each) do
    SiteVersion.instance_variable_set(:@permalinks, nil) # Invalidating memoization
  end

  describe '.localize_url' do
    before(:each) { create(:site_version, permalink: 'pt') }

    describe 'given a URL and a site version' do
      context 'URL is invalid' do
        let(:url) { 'not a url' }
        let(:site_version) { build_stubbed(:site_version, permalink: 'fr') }

        it 'returns the same input URL' do
          result = described_class.localize_url(url, site_version)
          expect(result).to eq('not a url')
        end
      end

      context 'URL does not have a locale in it' do
        let(:url) { 'http://example.com/something?color=red&everything=else' }
        let(:site_version) { build_stubbed(:site_version, permalink: 'fr') }

        it 'prepends the site version permalink into the URL' do
          result = described_class.localize_url(url, site_version)
          expect(result).to eq('http://example.com/fr/something?color=red&everything=else')
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
        let(:url) { 'http://example.com/something?color=pastel' }
        let(:site_version) { build_stubbed(:site_version, default: true) }

        it 'only uses the request fullpath' do
          result = described_class.localize_url(url, site_version)
          expect(result).to eq('http://example.com/something?color=pastel')
        end
      end
    end
  end

  describe '.remove_version_from_url' do
    context 'given an URL with a site version' do
      before(:each) { create(:site_version, permalink: 'pt') }

      it 'remove any known site version from it' do
        result = described_class.remove_version_from_url('/pt/something?query=cool')
        expect(result).to eq('/something?query=cool')
      end
    end

    context 'given an URL/path without a site version' do
      it 'does nothing on URLs' do
        given_url = 'http://example.com/pt/something?query=cool'
        result = described_class.remove_version_from_url(given_url)
        expect(result).to eq(given_url)
      end

      it 'does nothing on paths' do
        given_path = '/something?query=cool'
        result = described_class.remove_version_from_url(given_path)
        expect(result).to eq(given_path)
      end
    end
  end
end
