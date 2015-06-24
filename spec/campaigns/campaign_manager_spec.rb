require 'spec_helper'

describe CampaignManager do
  context "#initialization" do
    it 'stores and allows access' do
      attrs = {
        storage: double('storage'),
        campaign_attrs: double('campaign_attrs'),
        current_order: double('current_order'),
        current_site_version: double('current_site_version')
      }

      manager = CampaignManager.new(attrs)

      attrs.each do |name, value|
        expect(manager.send(name)).to eq(value)
      end
    end
  end
end
