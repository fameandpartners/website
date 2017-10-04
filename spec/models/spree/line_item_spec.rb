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
      let(:default_line_item) { order.line_items.first }
      let(:fast_making_line_items) { FactoryGirl.create_list(:dress_item, 3, :fast_making, order: order) }
      let(:standard_making_line_items) { [default_line_item] + FactoryGirl.create_list(:dress_item, 3, order: order) }

      describe '::fast_making' do
        it 'returns fast making line items' do
          expect(fast_making_line_items.count).to eq(3)
          expect(standard_making_line_items.count).to eq(4)

          expect(order.line_items.fast_making).to eq(fast_making_line_items)
        end
      end

      describe '::standard_making' do
        it 'returns non fast making line items' do
          expect(fast_making_line_items.count).to eq(3)
          expect(standard_making_line_items.count).to eq(4)

          expect(order.line_items.standard_making).to eq(standard_making_line_items)
        end
      end
    end

    describe '#delivery_period' do
      xit "delegates delivery period to policy" do
        delivery_period = double(:delivery_period)
        is_expected.to receive(:delivery_period_policy).and_return(double(:policy, delivery_period: delivery_period))

        expect(subject.delivery_period).to eq(delivery_period)
      end
    end
  end
end
