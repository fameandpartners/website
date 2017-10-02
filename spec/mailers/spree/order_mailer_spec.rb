require 'spec_helper'

module Spree
  RSpec.describe OrderMailer, type: :mailer do
    let(:today_date) { Time.zone.parse('05/05/2016') }
    let(:delivery_date) { Time.zone.parse('10/10/2016') }

    let(:user) { build(:spree_user, email: 'loroteiro@silvestre.com') }
    let(:address) { build(:address, address1: 'Street Macarena', address2: 'Around the Corner',
                          zipcode: '12321', city: 'Las Ketchup', phone: '1234-5678') }
    let(:order) { create(:complete_order_with_items, number: 'R123123123', projected_delivery_date: delivery_date,
                         user: user, bill_address: address, ship_address: address) }
    let(:presenter) { Marketing::OrderPresenter.new(order) }

    before(:each) { Spree::Config[:site_name] = 'My Super eCommerce' }

    let(:expected_attributes) {
      {
        # Calculated attributes. TODO on assertive values
        email_to:                    'loroteiro@silvestre.com',
        subject:                     'My Super eCommerce Order Confirmation #R123123123',
        order_number:                'R123123123',
        line_items:                  presenter.build_line_items,
        display_item_total:          order.display_item_total.to_s,
        adjustments:                 presenter.build_adjustments,
        display_total:               order.display_total.to_s,
        auto_account:                false,
        today:                       '05.05.16',
        phone:                       '1234-5678',
        delivery_date:               'Mon, 10 Oct 2016',
        billing_address_attributes:  presenter.billing_address_attributes.to_h,
        shipping_address_attributes: presenter.shipping_address_attributes.to_h,
        billing_address:             'Street Macarena Around the Corner, Las Ketchup, Alabama, 12321, United States of Foo',
        shipping_address:            'Street Macarena Around the Corner, Las Ketchup, Alabama, 12321, United States of Foo',
        cny_delivery_delay:          false,
        order_delivery_period:       '7 - 10 business days'
      }
    }

    it 'sends data to customerio correctly' do
      Timecop.freeze(today_date) do
        expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(order.user, 'order_confirmation_email', expected_attributes)
        described_class.confirm_email(order)
      end
    end
  end
end
