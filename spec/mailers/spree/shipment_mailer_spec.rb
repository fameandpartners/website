require 'spec_helper'

module Spree
  RSpec.describe ShipmentMailer, type: :mailer do
    let(:today_date) { Date.parse('05/05/2016') }
    let(:delivery_date) { Date.parse('10/10/2016') }

    let(:user) { build(:spree_user, email: 'loroteiro@silvestre.com') }
    let(:address) { build(:address, address1: 'Street Macarena', address2: 'Around the Corner',
                          zipcode: '12321', city: 'Las Ketchup', phone: '1234-5678') }
    let(:order) { create(:complete_order_with_items, number: 'R123123123', projected_delivery_date: delivery_date,
                         user: user, bill_address: address, ship_address: address) }
    let(:presenter) { Marketing::OrderPresenter.new(order) }
    let(:shipment) { build(:simple_shipment) }

    before(:each) do
      Spree::Config[:site_name] = 'My Super eCommerce'
      allow(Date).to receive(:today).and_return(today_date)

      allow(shipment).to receive(:order).and_return(order)
      allow(order).to receive(:shipment).and_return(shipment)
    end

    let(:expected_attributes) {
      {
        email_to:              'loroteiro@silvestre.com',
        from:                  'noreply@fameandpartners.com',
        subject:               "Hey babe, your dress is on it's way - Order: #R123123123",
        date:                  'May  5, 2016',
        name:                  user.first_name,
        shipment_method_name:  shipment.shipping_method.name,
        order_number:          order.number,
        line_items:            presenter.build_line_items,
        shipment_tracking:     shipment.tracking,
        shipment_tracking_url: shipment.tracking_url,
        billing_address:       'Street Macarena Around the Corner, Las Ketchup, Alabama, 12321, United States of Foo',
        shipping_address:      'Street Macarena Around the Corner, Las Ketchup, Alabama, 12321, United States of Foo',
        phone:                 address.phone,
        delivery_date:         'Sun, 09 Oct 2016',
        original_order_date:   '12 Aug 2016',
        display_item_total:    "$198.37",
        display_total:         "$198.37",
        auto_account:          false,
        currency:              order.currency,
        shipping_amount:       0.0,
        tax:                   nil,
        adjustments:           [{ label: "Shipping", display_amount: "$0.00" }]
      }
    }

    it 'sends data to customerio correctly' do
      expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(order.user, 'shipment_mailer', expected_attributes)
      described_class.shipped_email(shipment)
    end
  end
end
