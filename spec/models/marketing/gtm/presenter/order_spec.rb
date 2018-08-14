require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Order, type: :presenter do
        let(:line_item) { build(:dress_item, quantity: 2, price: 12.34) }
        let(:order) { build(:complete_order, id: '123456789', email: 'something@intheway.com', number: 'R123456', currency: 'AUD', line_items: [line_item]) }

        subject(:presenter) { described_class.new(spree_order: order) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          before(:each) do
            order.save
            expect(order).to receive(:line_items).and_return([]) # LineItem GTM has its own specs
          end

          context 'given a spree order' do
            it 'returns hash order details' do
              expect(order).to receive(:promotions).and_return([double('promo', code: 'C336V398', event_name: "spree.checkout.coupon_code_added")])
              expect(subject.body).to eq({
                                             id:                     123456789,
                                             coupon_code:            'C336V398',
                                             currency:               'AUD',
                                             email:                  'something@intheway.com',
                                             line_items:             [],
                                             discount_amount:        0.0,
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
