require 'spec_helper'

describe TopBanner do
  let(:site_version) { build_stubbed(:site_version, permalink: 'au') }
  subject { described_class.new(site_version) }

  before(:each) do
    Spree::AppConfiguration.class_eval do
      preference :au_top_banner_center_text, :string, default: 'Center Text Value'
      preference :au_top_banner_right_text , :string, default: 'Right Text Value'
    end
  end

  describe '#right_text_key' do
    it 'returns the right text preference key' do
      expect(subject.right_text_key).to eq('au_top_banner_right_text')
    end
  end

  describe '#center_text_key' do
    it 'returns the center text preference key' do
      expect(subject.center_text_key).to eq('au_top_banner_center_text')
    end
  end

  describe '#center_text' do
    it 'returns the center preference value' do
      expect(subject.center_text).to eq('Center Text Value')
    end
  end

  describe '#right_text' do
    it 'returns the right preference value' do
      expect(subject.right_text).to eq('Right Text Value')
    end
  end
end