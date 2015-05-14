require 'spec_helper'

describe OrderReturnRequest do

  let(:line_items)      { [stub_model(Spree::LineItem)] }
  let(:order)           { stub_model(Spree::Order) }

  let(:return_request)  { OrderReturnRequest.new(:order => order) }

  before do
    allow(order).to receive(:line_items).and_return(line_items)
  end

  it 'should build the associated items' do
    return_request.build_items
    expect(return_request).to have(1).return_request_items
  end

end
