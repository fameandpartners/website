require 'spec_helper'

module Spree
  RSpec.describe LineItem do
    describe '#promotional_gift?' do
      subject(:item) { build :line_item, product: product }

      context 'Gift' do
        let(:product) { build :spree_product, name: 'Gift' }

        it { expect(item.promotional_gift?).to be_truthy }
      end

      context 'Regular Dress' do
        let(:product) { build :spree_product }
        it { expect(item.promotional_gift?).to be_falsey }
      end
    end

    context 'scopes' do
      let(:order) do
        FactoryGirl.create(:complete_order_with_items).tap do |o|
          shipment = FactoryGirl.build(:simple_shipment, order: o)
          FactoryGirl.create(:inventory_unit, variant: o.line_items.last.product.master, order: o, shipment: shipment)
        end
      end
      let(:fast_making_line_items) { FactoryGirl.create_list(:dress_item, 3, :fast_making, order: order) }
      let(:standard_making_line_items) { FactoryGirl.create_list(:dress_item, 3, order: order) }

      describe '::fast_making' do
        it 'returns fast_making line items' do
          expect(order.line_items.fast_making).to eq(fast_making_line_items)
        end
      end
    end
  end
end
