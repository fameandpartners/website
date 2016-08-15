require 'spec_helper'

describe Marketing::OrderPresenter, type: :presenter do
  let(:presenter) { described_class.new(order) }

  describe 'delegates to Spree::Order' do
    let(:order) { build_stubbed(:spree_order, email: 'loroteiro@silvestre.com', number: 'R123123123', currency: 'BRL') }
    it('#currency') { expect(presenter.currency).to eq('BRL') }
    it('#email') { expect(presenter.email).to eq('loroteiro@silvestre.com') }
    it('#number') { expect(presenter.number).to eq('R123123123') }
  end

  describe 'instance methods' do
    let(:dress_color) { build(:product_colour, name: 'blue') }
    let(:dress_size) { build(:product_size, name: 'US10/AU14') }
    let(:dress_item_personalization) { build(:personalization, height: 'petite', color: dress_color, size: dress_size) }
    let(:dress_variant) { create(:dress_variant) }
    let(:dress_item) { build(:dress_item, price: 9.99, quantity: 1, personalization: dress_item_personalization,
                             variant: dress_variant) }
    let(:adjustment) { create(:adjustment, adjustable_type: 'Spree::Order') }
    let(:order) { build(:spree_order, number: 'R123', currency: 'BRL', line_items: [dress_item],
                        adjustments: [adjustment], projected_delivery_date: Date.new, site_version: 'us') }

    it 'build_line_items' do
      result = presenter.build_line_items.first
      expect(result[:sku]).to eq(dress_item.variant.sku)
      expect(result[:name]).to eq(dress_item.variant.product.name)
      expect(result[:making_options_text]).to eq(dress_item.making_options_text)
      expect(result[:options_text]).to eq(dress_item.options_text)
      expect(result[:quantity]).to eq(dress_item.quantity)
      expect(result[:variant_display_amount]).to eq(dress_item.variant.display_amount.to_s)
      expect(result[:display_amount]).to eq(dress_item.display_amount.to_s)

      # expect(result[:image_url]).to eq(nil) # TODO: Image URL should point to the cropped version, like the cart at the storefront
      expect(result[:height]).to eq('petite')
      expect(result[:color]).to eq('blue')
      expect(result[:size]).to eq('US10')
    end

    it 'build_adjustments' do
      result = presenter.build_adjustments.first
      expect(result[:label]).to eq(order.adjustments.eligible.first.label)
      expect(result[:display_amount]).to eq(order.adjustments.eligible.first.display_amount.to_s)
    end

    describe '#total_amount' do
      it 'returns the total amount of an order' do
        allow(order).to receive(:total).and_return(12.34)
        expect(presenter.total_amount).to eq(12.34)
      end
    end

    describe '#taxes_amount' do
      let(:adjustment) { create(:adjustment, amount: 12.3) }

      before(:each) do
        active_record_relation = Spree::Adjustment.where(id: adjustment.id)
        allow(order).to receive_message_chain(:adjustments, :tax).and_return(active_record_relation)
      end

      it 'returns the total tax amount' do
        expect(presenter.taxes_amount).to eq(12.3)
      end
    end

    describe '#shipping_amount' do
      let(:adjustment) { create(:adjustment, amount: 12.3) }

      before(:each) do
        active_record_relation = Spree::Adjustment.where(id: adjustment.id)
        allow(order).to receive_message_chain(:adjustments, :shipping).and_return(active_record_relation)
      end

      it 'returns the total shipping cost' do
        expect(presenter.shipping_amount).to eq(12.3)
      end
    end
  end
end
