require 'spec_helper'

describe SiteVersion, type: :model, memoization_support: true do
  describe '.permalinks' do
    before(:each) { rememoize(described_class, :@permalinks) }

    it 'returns all site versions permalinks' do
      create(:site_version, permalink: 'au')

      # Notice that 'us' version was seeded in the spec_helper
      result = described_class.permalinks
      expect(result).to match(['us', 'au'])
    end
  end

  describe '.by_permalink_or_default' do
    let!(:default_site_version) { described_class.default }
    let!(:au_site_version) { create(:site_version, permalink: 'au') }

    context 'given an existent locale permalink' do
      it 'returns the SiteVersion of the permalink' do
        result = described_class.by_permalink_or_default('au')
        expect(result).to eq(au_site_version)
      end
    end

    context 'given an inexistent locale permalink' do
      it 'returns the default SiteVersion' do
        result = described_class.by_permalink_or_default('jp')
        expect(result).to eq(default_site_version)
      end
    end

    context 'given a nil locale permalink' do
      it 'returns the default SiteVersion' do
        result = described_class.by_permalink_or_default(nil)
        expect(result).to eq(default_site_version)
      end
    end
  end

  describe '#to_param' do
    context 'default site version' do
      let(:site_version) { build_stubbed(:site_version, default: true, permalink: 'us') }

      it 'returns an empty string' do
        expect(site_version.to_param).to eq('')
      end
    end

    context 'not default site version' do
      let(:site_version) { build_stubbed(:site_version, permalink: 'au') }

      it 'returns the code of the site version' do
        expect(site_version.to_param).to eq('au')
      end
    end
  end
end
