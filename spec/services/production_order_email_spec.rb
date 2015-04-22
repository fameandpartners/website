require 'spec_helper'

describe ProductionOrderEmailService do

  def item(factory = 'Vtha')
    double(Spree::LineItem, :factory => factory)
  end

  let(:v_items)     { [item, item] }
  let(:b_items)     { [item('Blah')] }
  let(:line_items)  { v_items + b_items }
  let(:order)       { double(:id => 99, :number => 'ABCDEF123', :line_items => line_items) }
  let(:mailer)      { double(Spree::OrderMailer) }

  subject(:service) { ProductionOrderEmailService.new(order.id) }

  before do
    expect(Spree::Order).to receive(:find).with(order.id).and_return(order)

  end

  it 'send emails for each factory' do

    expect(mailer).to receive(:deliver).twice
    expect(Spree::OrderMailer).to receive(:production_order_email).with(order, 'Vtha', v_items).and_return(mailer)
    expect(Spree::OrderMailer).to receive(:production_order_email).with(order, 'Blah', b_items).and_return(mailer)

    service.deliver
  end

end
