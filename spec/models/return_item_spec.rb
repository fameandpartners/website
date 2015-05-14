require 'spec_helper'

describe ReturnRequestItem do

  let(:line_item) { stub_model(Spree::LineItem) }
  let(:order)      { stub_model(Spree::Order) }
  let(:action)     { nil }

  subject(:return_request_item) { ReturnRequestItem.new(:line_item => line_item, :action => action) }

  it{ is_expected.to be_keep}
  it{ is_expected.to be_valid}

  context 'when return or exchanged' do
    let(:action)     { 'return' }

    it 'validates reasons' do
      expect(return_request_item).to be_invalid

      return_request_item.reason_category = 'OH NOES'
      return_request_item.reason = 'BORKED'
      expect(return_request_item).to be_valid
    end

  end

end
