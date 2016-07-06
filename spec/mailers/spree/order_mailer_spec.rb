require 'spec_helper'

module Spree
  RSpec.describe OrderMailer, type: :mailer do
    let(:today_date) { Date.parse('05/05/2016') }
    let(:delivery_date) { Date.parse('10/10/2016') }

    let(:user) { build(:spree_user, email: 'loroteiro@silvestre.com') }
    let(:address) { build(:address, address1: 'Street Macarena', address2: 'Around the Corner', zipcode: '12321', city: 'Las Ketchup', phone: '1234-5678') }
    let(:order) { create(:complete_order_with_items, number: 'R123123123', projected_delivery_date: delivery_date, user: user, bill_address: address, ship_address: address) }

    before(:each) do
      Spree::Config[:site_name] = 'My Super eCommerce'
      allow(Date).to receive(:today).and_return(today_date)
      allow_any_instance_of(Marketing::OrderPresenter).to receive_messages(billing_address: {}, shipping_address: {})
    end

    let(:expected_attributes) {
      {
        # Calculated attributes. TODO on assertive values
        adjustments:                 Marketing::OrderPresenter.build_adjustments(order),
        display_item_total:          order.display_item_total.to_s,
        display_total:               order.display_total.to_s,
        line_items:                  Marketing::OrderPresenter.build_line_items(order),
        billing_address_attributes:  {}, # Empty Hash. Tested in Marketing::AddressPresenter
        shipping_address_attributes: {}, # Empty Hash. Tested in Marketing::AddressPresenter
        # Delegated attributes. Easy to process
        auto_account:                false,
        billing_address:             'Street Macarena Around the Corner, Las Ketchup, Alabama, 12321, United States of Foo',
        delivery_date:               'Sun, 09 Oct 2016',
        email_to:                    'loroteiro@silvestre.com',
        order_number:                'R123123123',
        phone:                       '1234-5678',
        shipping_address:            'Street Macarena Around the Corner, Las Ketchup, Alabama, 12321, United States of Foo',
        subject:                     'My Super eCommerce Order Confirmation #R123123123',
        today:                       '05.05.16',
      }
    }

    it 'sends data to customerio correctly' do
      expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(order.user, 'order_confirmation_email', expected_attributes)
      described_class.confirm_email(order)
    end
  end
end
