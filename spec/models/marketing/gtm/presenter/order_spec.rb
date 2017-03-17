require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Order, type: :presenter do
        subject(:order)     { FactoryGirl.create(:complete_order_with_items) }
        subject(:presenter) { described_class.new(spree_order: order) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          before(:each) do
            order.save
            expect(order).to receive(:line_items).twice.and_return([]) # LineItem GTM has its own specs
          end

          context 'given a spree order' do
            it 'returns hash order details' do
              expect(subject.body).to eq({
                                             coupon_code:            'C336V398',
                                             currency:               'AUD',
                                             email:                  'something@intheway.com',
                                             line_items:             [],
                                             line_items_summary:     [],
                                             number:                 'R123456',
                                             shipping_amount:        0.0,
                                             taxes_amount:           0.0,
                                             total_amount:           24.68,
                                             humanized_total_amount: '24.68'
                                         })
            end
          end
        end
      end
    end
  end
end
