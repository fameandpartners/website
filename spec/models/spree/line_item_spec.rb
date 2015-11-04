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
  end
end
