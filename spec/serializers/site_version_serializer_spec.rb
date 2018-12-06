require 'spec_helper'

RSpec.describe SiteVersionSerializer do

  subject(:serializer) { described_class.new(default_site) }

  describe '#url_prefix' do
    let(:default_site) do
      FactoryGirl.build(:site_version, permalink: 'ds', name: 'Murica', currency: 'USD', default: true)
    end

    let(:blank_url_prefix) do
      {
        name:       default_site.name,
        permalink:  default_site.permalink,
        currency:   default_site.currency,
      }.to_json
    end

    it 'serializes' do
      expect(serializer.to_json(root: nil)).to eq(blank_url_prefix)
    end
  end
end
