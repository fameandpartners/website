require 'spec_helper'

describe RefundMailer, type: :mailer do
  let(:user) { FactoryGirl.create(:spree_user) }
  let(:order) { FactoryGirl.create(:complete_order, user: user) }
  let(:line_item) { FactoryGirl.build(:dress_item, order: order) }
  let(:item_return) { FactoryGirl.create(:item_return, line_item: line_item) }
  let(:event) { double(ItemReturnEvent, item_return: item_return, data: { refund_amount: '42' }) }

  let(:expected_attributes) {
    {
      email_to:     user.email,
      subject:      "Refund notification for order #{order.number}",
      amount:       '42',
      order_number: order.number
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
