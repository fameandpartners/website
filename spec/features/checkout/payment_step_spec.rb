require 'spec_helper'

describe 'Order Payment Step', type: :feature do
  let!(:user) { FactoryGirl.create(:spree_user) }
  let!(:order) { FactoryGirl.create(:spree_order, state: 'payment', shipments: [shipment], user: user) }
  let!(:shipment) { FactoryGirl.create(:simple_shipment) }
  let!(:line_items) { FactoryGirl.create(:dress_item, order: order) }

  before(:each) do
    allow_any_instance_of(Spree::CheckoutController).to receive_messages(
      current_order:          order,
      try_spree_current_user: user
    )
  end

  describe 'render localized PayPal button' do
    let!(:paypal_usd) { FactoryGirl.create(:paypal_express, :active, id: 123, preferred_currency: 'USD') }
    let!(:paypal_aud) { FactoryGirl.create(:paypal_express, :active, id: 456, preferred_currency: 'AUD') }

    before(:each) do
      allow_any_instance_of(Spree::CheckoutController).to receive(:current_site_version).and_return(site_version)
    end

    context 'on the USA site version' do
      let(:site_version) { FactoryGirl.create(:site_version, :us) }

      xit 'renders USD button' do
        visit spree.checkout_state_path('payment')

        expect(page).to have_link('paypal_button', href: '/paypal?payment_method_id=123')
      end
    end

    context 'on the Australian site version' do
      let(:site_version) { FactoryGirl.create(:site_version, :au) }

      xit 'renders AUD button' do
        visit spree.checkout_state_path('payment')

        expect(page).to have_link('paypal_button', href: '/paypal?payment_method_id=456')
      end
    end
  end
end
