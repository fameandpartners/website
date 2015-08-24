require 'spec_helper'

describe Preferences::TopBanner, type: :presenter, spree_config_support: true do
  let(:spree_config) { Spree::AppConfiguration.new }
  let(:site_version) { build_stubbed(:site_version, permalink: 'au') }
  let(:banner)       { described_class.new(site_version) }

  describe '#right_text_key' do
    it 'returns the right text preference key' do
      expect(banner.right_text_key).to eq('au_top_banner_right_text')
    end
  end

  describe '#center_text_key' do
    it 'returns the center text preference key' do
      expect(banner.center_text_key).to eq('au_top_banner_center_text')
    end
  end

  describe '#center_text' do
    it 'returns the center preference value' do
      define_spree_config_preference(:au_top_banner_center_text, 'Center Text Value', :string)
      expect(banner.center_text).to eq('Center Text Value')
    end
  end

  describe '#right_text' do
    it 'returns the right preference value' do
      define_spree_config_preference(:au_top_banner_right_text, 'Right Text Value', :string)
      expect(banner.right_text).to eq('Right Text Value')
    end
  end
end
