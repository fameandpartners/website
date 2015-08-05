require 'spec_helper'

describe Spree::BannerBox, type: :model do
  describe 'scopes' do
    let!(:au_site_version)  { build_stubbed(:site_version, permalink: 'au') }
    let!(:us_big_banner)   { create(:banner_box, is_small: false, css_class: 'us') }
    let!(:au_small_banner) { create(:banner_box, is_small: true, css_class: 'au') }

    describe '.big_banner' do
      it 'returns only big banners' do
        result = described_class.big_banner
        expect(result).to eq([us_big_banner])
      end
    end

    describe '.small_banner' do
      it 'returns only small banners' do
        result = described_class.small_banner
        expect(result).to eq([au_small_banner])
      end
    end

    describe '.for_site_version' do
      it 'returns only banners with AU css classe' do
        result = described_class.for_site_version(au_site_version)
        expect(result).to eq([au_small_banner])
      end
    end
  end
end
