require 'spec_helper'

describe Policies::OrderProjectedDeliveryDatePolicy do

  let(:completed_at)  { DateTime.parse('Wed April 1 2015') }
  let(:order)         { double(Spree::Order, :completed_at => completed_at) }

  subject(:service)   { Policies::OrderProjectedDeliveryDatePolicy.new(order) }

  it '#delivery_date' do
    expected_date = DateTime.parse('Friday April 10 2015')
    expect(service.delivery_date).to eq expected_date
  end

end
