require 'spec_helper'

describe LocaleWarn, type: :presenter, spree_config_support: true do
  let(:spree_config) { Spree::AppConfiguration.new }
  let(:site_version) { build_stubbed(:site_version, permalink: 'au') }
  let(:warn)         { described_class.new(site_version) }

  describe '#initialize' do
    it 'guarantees application preferences for the given site version' do
      expect(spree_config.has_preference?(:au_locale_warn_text)).to be_falsy
      described_class.new(site_version)
      expect(spree_config.has_preference?(:au_locale_warn_text)).to be_truthy
    end
  end

  describe '#flag_url' do
    it 'returns the flag url' do
      expect(warn.flag_url).to eq('flags/bigger/au.gif')
    end
  end

  describe '#button_text' do
    it 'returns the button text (with site version code upcased)' do
      expect(warn.button_text).to eq('Visit our AU Store')
    end
  end

  describe '#long_text_key' do
    it 'returns the long text preference key' do
      expect(warn.long_text_key).to eq('au_locale_warn_text')
    end
  end

  describe '#long_text' do
    it 'returns the long text preference value' do
      define_spree_config_preference(:au_locale_warn_text, 'AU Locale Warn Text', :string)
      expect(warn.long_text).to eq('AU Locale Warn Text')
    end
  end
end
