require 'spec_helper'

describe Spree::Order do

  let(:completed_at)  { DateTime.parse('Wed April 1 2015') }
  let(:order)         { Spree::Order.new }

  before do
    allow(order).to receive(:completed_at).and_return(completed_at)
  end

  it '#delivery_date' do
    expected_date = DateTime.parse('Friday April 10 2015')
    expect(order).to receive(:update_attributes!).with(:projected_delivery_date => expected_date)
    order.project_delivery_date
  end

end
