require 'spec_helper'

describe SiteVersion, :type => :model do
  describe '.by_permalink_or_default' do
    let!(:default_site_version) { SiteVersion.default }
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
end