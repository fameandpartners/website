require 'spec_helper'

RSpec.describe CheckoutHelper, :type => :helper do

  let!(:user) { create(:spree_user) }
  let!(:address) { create(:address, email: user.email) }
  let(:zone) {  Spree::Zone.find(4) }
  let(:current_site_version) { create(:site_version) }
  let(:usa_id) { Spree::Country.where(name: "United States").first.id }
  let(:address1) { set_us_default(address) }
  let!(:checkout_zone) { 'us' }

  describe '#set_us_default' do

    context 'given the user is in the usa zone' do
      before do
        current_site_version.permalink = 'us'
        current_site_version.zone = zone
      end

      it 'has an address with a country not in the USA zone' do
        address.country_id = Spree::Country.where(name: "Australia").first.id
        expect(address1.country_id).to eq(usa_id)
      end

      it 'is has the country for address is USA' do
        address.country_id = usa_id
        expect(address1.country_id).to eq(address.country_id)
      end

      it 'has the country for address as not USA' do
        address.country_id = Spree::Country.where(name: "Canada").first.id
        expect(address1.country_id).to eq(address.country_id)
      end

      it 'has not set the country for address' do
        address.country_id = nil
        expect(address1.country_id).to eq(address.country_id)
      end

    end

    context 'au' do
      before do
        current_site_version.permalink = 'au'
      end

      it 'does not change the address country_id' do
        expect(address1.country_id).to eq(address.country_id)
      end

    end

  end
end
