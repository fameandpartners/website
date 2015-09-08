require 'spec_helper'

describe Preferences::Titles, type: :presenter, spree_config_support: true do
  let(:spree_config) { Spree::AppConfiguration.new }
  let(:site_version) { build_stubbed(:site_version, permalink: 'au') }
  let(:banner)       { described_class.new(site_version) }

  describe '#homepage_title_key' do
    it 'returns the right homepage_title preference key' do
      expect(banner.homepage_title_key).to eq('au_homepage_title')
    end
  end

  describe '#homepage_title' do
    it 'returns the homepage title preference value' do
      define_spree_config_preference(:au_homepage_title, 'AU Home Page Title', :string)
      expect(banner.homepage_title).to eq('AU Home Page Title')
    end
  end
end
