require 'spec_helper'

describe Spree::Order, :type => :model do
  let(:order)         { Spree::Order.new }
  let(:completed_at)  { DateTime.parse('Wed April 1 2015') }

  before do
    allow(order).to receive(:complete?).and_return(true)
    allow(order).to receive(:completed_at).and_return(completed_at)
  end

  it '#project_delivery_date' do
    expected_date = DateTime.parse('Friday April 10 2015')
    expect(order).to receive(:update_attribute).with(:projected_delivery_date, expected_date)
    order.project_delivery_date
  end
end
