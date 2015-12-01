require 'spec_helper'

describe 'orders', type: :feature do
  context 'user changes site version' do

    shared_examples 'does not drop current order' do
      let!(:us_site_version) { create(:site_version, permalink: 'us', currency: 'USD', default: true) }
      let!(:au_site_version) { create(:site_version, permalink: 'au', currency: 'AUD', default: false) }

      it 'user navigates to a different site version' do
        visit 'us.fameandpartners.test'
        visit 'au.fameandpartners.test'

        au_order = Spree::Order.first
        expect(au_order.currency).to eq 'AUD'

        expect(Spree::Order.count).to eq 1
      end
    end

    context 'user is logged in' do
      before(:each) { login_user }

      include_examples 'does not drop current order'
    end

    context 'user is a guest' do
      include_examples 'does not drop current order'
    end
  end
end
