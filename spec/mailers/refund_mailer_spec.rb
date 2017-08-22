require 'spec_helper'

describe RefundMailer, type: :mailer do
  let(:user) { FactoryGirl.create(:spree_user) }
  let(:address) { FactoryGirl.create(:address) }
  let(:order) { FactoryGirl.create(:complete_order, user: user, billing_address: address) }
  let(:line_item) { FactoryGirl.build(:dress_item, order: order) }
  let(:item_return) { FactoryGirl.create(:item_return, line_item: line_item) }
  let(:event) { double(ItemReturnEvent, item_return: item_return, user: user, data: { refund_amount: '42' }) }

  let(:product_data) {
    {
      name: line_item&.product&.name,
      size: line_item&.cart_item&.size&.presentation,
      color: line_item&.cart_item&.color&.presentation,
      image: line_item&.cart_item&.image&.large,
      price: line_item&.price,
      height_copy: nil
    }
  }

  let(:user_return_object) {
    {
      "order_number": order.number,
      "first_name": user.first_name,
      "last_name": user.last_name,
      "email": user.email,
      "total_refund": event.refund_amount,
      "address": {
        address_one: address&.address1,
        address_two: address&.address2,
        city: address&.city,
        state: address&.state&.abbr,
        zipcode: address&.zipcode
      },
      "item": product_data
    }
  }

  let(:expected_attributes) {
    {
      email_to: user.email,
      user_data: user_return_object
    }
  }

  before do
    allow(event).to receive(:refund_amount).and_return('42')
  end

  describe '#notify_user' do
    it 'sends data to customerio correctly' do
      expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(order.user, 'refund_notification_email', expected_attributes)

      RefundMailer.notify_user(event).deliver
    end
  end
end
