require 'spec_helper'

describe Feeds::Base do
  describe '.initialize' do
    let(:default_config) do
      {
        title: 'Fame & Partners',
        description: 'Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.'
      }
    end

    context 'given the default site version permalink' do
      let!(:default_site_version) { create(:site_version, permalink: 'jp', default: true) }

      it 'configures @current_site_version' do
        base_feed = described_class.new('jp')
        expect(base_feed.current_site_version).to eq(default_site_version)
      end

      it 'configures @config hash with a title, description and domain' do
        base_feed = described_class.new('jp')
        expect(base_feed.config).to match(default_config.merge(domain: 'http://fameandpartners.test'))
      end
    end

    context 'given other site version permalink' do
      let!(:other_site_version) { create(:site_version, permalink: 'pt') }

      it 'configures @current_site_version' do
        base_feed = described_class.new('pt')
        expect(base_feed.current_site_version).to eq(other_site_version)
      end

      it 'configures @config hash with a title, description and domain' do
        base_feed = described_class.new('pt')
        expect(base_feed.config).to match(default_config.merge(domain: 'http://fameandpartners.test/pt'))
      end
    end
  end
end
