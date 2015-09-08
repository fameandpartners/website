require 'spec_helper'

describe Preferences::SEO, type: :presenter, spree_config_support: true do
  let(:spree_config) { Spree::AppConfiguration.new }
  let(:site_version) { build_stubbed(:site_version, permalink: 'au') }
  let(:banner)       { described_class.new(site_version) }

  describe '#default_seo_title_key' do
    it 'returns the right default_seo_title preference key' do
      expect(banner.default_seo_title_key).to eq('au_default_seo_title')
    end
  end

  describe '#default_meta_description_key' do
    it 'returns the right default_meta_description preference key' do
      expect(banner.default_meta_description_key).to eq('au_default_meta_description')
    end
  end

  describe '#default_seo_title' do
    it 'returns the default_seo_title preference value' do
      define_spree_config_preference(:au_default_seo_title, 'AU SEO Title', :string)
      expect(banner.default_seo_title).to eq('AU SEO Title')
    end
  end

  describe '#default_meta_description' do
    it 'returns the default_meta_description preference value' do
      define_spree_config_preference(:au_default_meta_description, 'AU Meta Description', :string)
      expect(banner.default_meta_description).to eq('AU Meta Description')
    end
  end
end
