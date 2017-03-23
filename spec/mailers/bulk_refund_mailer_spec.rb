require 'spec_helper'

describe BulkRefundMailer, type: :mailer do
  let(:events) do
    3.times.map { |i| double(ItemReturnEvent, data: { refund_amount: '42' }, id: i) }
  end

  let(:expected_attributes) do
    {
      email_to: "",
      subject:  "Bulk refund report",
      events:   [ 0, 1, 2 ]
    }
  end

  describe '#report' do
    it 'sends data to customerio correctly' do
      expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(nil, 'bulk_refund_report_email', expected_attributes)

      BulkRefundMailer.report(events).deliver
    end
  end
end
