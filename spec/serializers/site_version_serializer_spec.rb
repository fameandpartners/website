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
end
