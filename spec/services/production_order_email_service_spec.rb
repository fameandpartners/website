require 'spec_helper'

describe ProductionOrderEmailService do

  def item(factory = 'Vtha')
    double(Spree::LineItem, :factory => factory)
  end

  let(:v_items)     { [item, item] }
  let(:b_items)     { [item('Blah')] }
  let(:line_items)  { v_items + b_items }
  let(:order)       { double(id:         99,
                             number:     'ABCDEF123',
                             line_items: line_items,
                             user:       Faker.name) }

  it 'groups items by factory' do
    service = ProductionOrderEmailService.new(order)

    expect(service).to receive(:trigger_email).with(order, 'Vtha', v_items)
    expect(service).to receive(:trigger_email).with(order, 'Blah', b_items)

    service.deliver
  end
end
