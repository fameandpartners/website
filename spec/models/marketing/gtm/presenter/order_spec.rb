require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Order, type: :presenter do
        let(:taxon) { create(:taxon, name: 'Jeans') }
        let(:product) { create(:dress, name: 'Super Dress', sku: 'ABC123', taxons: [taxon]) }
        let(:variant) { create(:dress_variant, product: product) }
        let(:line_item) { build(:dress_item, variant: variant, quantity: 2, price: 12.34) }
        let(:order) { build(:complete_order_with_items, number: 'R123456', currency: 'AUD', line_items: [line_item]) }

        subject(:presenter) { described_class.new(spree_order: order) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          before(:each) { order.save }

          context 'given a spree order' do
            it 'returns hash order details' do
              expect(subject.body).to eq({
                                             currency:        'AUD',
                                             line_items:      [
                                                                  { sku:          'ABC123',
                                                                    name:         'Super Dress',
                                                                    category:     'Jeans',
                                                                    total_amount: 24.68,
                                                                    quantity:     2 }
                                                              ],
                                             number:          'R123456',
                                             shipping_amount: 0.0,
                                             taxes_amount:    0.0,
                                             total_amount:    24.68
                                         })
            end
          end
        end
      end
    end
  end
end
