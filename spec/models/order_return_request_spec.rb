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

  describe '#sorted_return_request_items' do
    let(:line_items)      { [stub_model(Spree::LineItem), stub_model(Spree::LineItem), stub_model(Spree::LineItem)] }

    it 'puts return and exchange before keep' do
      return_request.build_items

      return_request.return_request_items.each_with_index do |rri, idx|
        rri.action = ReturnRequestItem::ACTIONS[idx]
      end
      expect(return_request.return_request_items.collect(&:action)).to        eq %w(keep exchange return)

      expect(return_request.sorted_return_request_items.collect(&:action)).to eq %w(return exchange keep)
    end
  end
end
