require 'spec_helper'

describe Preferences::LocaleWarnPresenter, type: :presenter do
  let(:au_site_version) { build_stubbed(:site_version, permalink: 'au', name: 'Australia') }
  let(:br_site_version) { build_stubbed(:site_version, permalink: 'br', name: 'Brazil') }

  describe '#flag_url' do
    it 'returns the flag url based on geo site version' do
      presenter = described_class.new(geo_site_version: br_site_version)
      expect(presenter.flag_url).to eq('flags/bigger/br.gif')
    end
  end

  describe '#button_text' do
    it 'returns the button text based on geo site version' do
      presenter = described_class.new(geo_site_version: br_site_version)
      expect(presenter.button_text).to eq('Visit our br Store')
    end
  end

  describe '#geo_site_version_url' do
    it 'calls up site_version_url helper method' do
      presenter = described_class.new(request_url: 'http://example.com', geo_site_version: au_site_version)
      expect(presenter).to receive(:site_version_url).with('http://example.com', au_site_version)
      presenter.geo_site_version_url
    end
  end

  describe '#long_text'do
    let(:presenter)  { described_class.new }
    let(:preference) { double('Locale Preference', long_text: 'My Long Locale Warn Text') }

    before(:each)    { allow(presenter).to receive(:preference).and_return(preference) }

    it 'returns locale warn preference long text' do
      expect(presenter.long_text).to eq('My Long Locale Warn Text')
    end
  end

  describe '#show?' do
    context 'returns true if' do
      it 'session site version is nil and current site version differs from geo' do
        presenter = described_class.new(geo_site_version: br_site_version, current_site_version: au_site_version, session_site_version_code: nil)
        expect(presenter.show?).to be_truthy
      end
    end

    context 'returns false if' do
      it 'session site version is set' do
        presenter = described_class.new(session_site_version_code: 'anything')
        expect(presenter.show?).to be_falsy
      end

      it 'current site version is the same as geo' do
        presenter = described_class.new(geo_site_version: br_site_version, current_site_version: br_site_version)
        expect(presenter.show?).to be_falsy
      end
    end
  end

  describe '#cache_key' do
    it 'returns the cache key composed by geo and current site version codes, and show boolean' do
      presenter = described_class.new(request_url: 'http://us.lvh.me/something', geo_site_version: br_site_version, current_site_version: au_site_version, session_site_version_code: nil)
      expect(presenter.cache_key).to eq('fa187f996c56fac64149be62ea937262-br-au-true')
    end
  end
end
