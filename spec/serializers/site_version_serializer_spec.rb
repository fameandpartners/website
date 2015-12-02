require 'spec_helper'

RSpec.describe SiteVersionSerializer do

  subject(:serializer) { described_class.new(site_version) }

  describe '#url_prefix' do
    let(:default_site) do
      FactoryGirl.build(:site_version, permalink: 'ds', name: 'Murica', currency: 'USD', default: true)
    end

    let(:blank_url_prefix) do
      {
        name:       default_site.name,
        permalink:  default_site.permalink,
        currency:   default_site.currency,
        url_prefix: ''
      }.to_json
    end

    let(:non_default_site) do
      FactoryGirl.build(:site_version, permalink: 'oz', name: 'Straya', currency: 'AUD', default: false)
    end

    let(:permalink_url_prefix) do
      {
        name:       non_default_site.name,
        permalink:  non_default_site.permalink,
        currency:   non_default_site.currency,
        url_prefix: non_default_site.permalink
      }.to_json
    end

    context 'default site version' do
      let(:site_version) { default_site }

      it 'is blank' do
        expect(serializer.to_json).to eq(blank_url_prefix)
      end
    end

    context 'non-default site version' do
      let(:site_version) { non_default_site }

      it 'is the permalink' do
        expect(serializer.to_json).to eq(permalink_url_prefix)
      end
    end
  end

  describe '#use_paths?' do
    let(:site_version_detector_strategy) { :path }
    let(:site_version)                   { build_stubbed(:site_version) }

    context 'site version detection is using path' do
      before(:each) do
        allow(serializer).to receive_message_chain(:configatron, :site_version_detector_strategy).and_return(site_version_detector_strategy)
      end

      it 'returns true' do
        expect(serializer.use_paths?).to be_truthy
      end
    end

    context 'site version detection is not using path' do
      before(:each) do
        allow(serializer).to receive_message_chain(:configatron, :site_version_detector_strategy).and_return(:not_path_strategy)
      end

      it 'returns false' do
        expect(serializer.use_paths?).to be_falsy
      end
    end
  end

  describe '#use_paths?' do
    let(:site_version) { build_stubbed(:site_version) }

    context 'site version detection is using path' do
      before(:each) do
        allow(serializer).to receive_message_chain(:configatron, :site_version_detector_strategy).and_return(:path)
      end

      it { expect(serializer.use_paths?).to be_truthy }
    end

    context 'site version detection is not using path' do
      before(:each) do
        allow(serializer).to receive_message_chain(:configatron, :site_version_detector_strategy).and_return(:not_path_strategy)
      end

      it { expect(serializer.use_paths?).to be_falsy }
    end
  end
end
