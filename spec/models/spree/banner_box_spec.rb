require 'spec_helper'

describe Spree::BannerBox, type: :model do
  describe '#url' do
    let(:valid_urls) {
      [
        'http://www.fameandpartners.com',
        'https://www.fameandpartners.com',
        Faker::Internet.http_url,
        Faker::Internet.uri('https')
      ]
    }

    let(:invalid_urls) {
      [
        'ftp://www.fameandpartners.com',
        'www.fameandpartners.com',
        Faker::Internet.uri('ftp'),
        Faker::Internet.domain_name
      ]
    }

    it { is_expected.not_to allow_value(invalid_urls).for(:url) }
    it { is_expected.to     allow_value(valid_urls).for(:url) }
  end

  describe 'scopes' do
    let!(:au_site_version) { build_stubbed(:site_version, permalink: 'au') }
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
