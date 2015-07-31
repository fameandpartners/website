require 'spec_helper'

describe Preferences::TopBanner, type: :model do
  let(:spree_config) { Spree::AppConfiguration.new }
  let(:site_version) { build_stubbed(:site_version, permalink: 'au') }
  let(:banner)       { described_class.new(site_version) }

  def define_spree_config_preference(key, value, type)
    Spree::AppConfiguration.class_eval do
      preference key, type
    end

    Spree.config do |config|
      config.send("#{key}=", value)
    end
  end

  describe '#initialize' do
    it 'guarantees application preferences for the given site version' do
      expect(spree_config.has_preference?(:au_top_banner_right_text)).to be_falsy
      expect(spree_config.has_preference?(:au_top_banner_center_text)).to be_falsy
      described_class.new(site_version)
      expect(spree_config.has_preference?(:au_top_banner_right_text)).to be_truthy
      expect(spree_config.has_preference?(:au_top_banner_center_text)).to be_truthy
    end
  end

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
