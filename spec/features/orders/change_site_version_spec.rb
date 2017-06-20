require 'spec_helper'

describe 'orders', type: :feature do
  context 'user changes site version' do

    shared_context 'US and AU site versions are created' do
      let!(:us_site_version) { create(:site_version, :us, :default) }
      let!(:au_site_version) { create(:site_version, :au) }
    end

    # contently broke this
    shared_examples 'does not drop current order' do
      xit 'user navigates to a different site version' do
        switch_to_subdomain 'us'
        visit '/'

        switch_to_subdomain 'au'
        visit '/'

        au_order = Spree::Order.first
        expect(au_order.currency).to eq 'AUD'

        expect(Spree::Order.count).to eq 1
      end
    end

    context 'user is logged in' do
      include_context 'US and AU site versions are created'

      before(:each) { login_user }

      include_examples 'does not drop current order'
    end

    context 'user is a guest' do
      include_context 'US and AU site versions are created'
      include_examples 'does not drop current order'
    end
  end
end
