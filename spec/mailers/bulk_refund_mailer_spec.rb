require 'spec_helper'

describe BulkRefundMailer, type: :mailer do
  let(:user) { FactoryGirl.create(:spree_user) }
  let(:statistics) do
    {
      error: [
        { 'item_return_id' => 104, 'result' => { 'message' => 'error1' } },
        { 'item_return_id' => 105, 'result' => { 'message' => 'error2' } },
        { 'item_return_id' => 106, 'result' => { 'message' => 'error3' } },
      ],
      success: [
        { 'item_return_id' => 101 },
        { 'item_return_id' => 102 },
        { 'item_return_id' => 103 }
      ]
    }
  end

  let(:expected_attributes) do
    {
      email_to: "finance@fameandpartners.com",
      subject:  "Bulk refund report",
      success: [ 101, 102, 103 ],
      fails: [ [ 104, 'error1' ], [ 105, 'error2' ], [ 106, 'error3' ] ]
    }
  end

  describe '#report' do
    it 'sends data to customerio correctly' do
      expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(user, 'bulk_refund_report_email', expected_attributes)

      BulkRefundMailer.report(statistics, user).deliver
    end
  end
end
