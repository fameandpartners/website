require 'spec_helper'

module Policy
  describe Product do
    describe '#customisation_allowed?' do

      let(:a_discount)  { 999 }
      let(:no_discount) { nil }

      let(:product) { double('product', :discount => discount) }

      subject(:policy) do
        Policy::Product.new(product)
      end

      context 'when discounted' do
        let(:discount) { a_discount }
        it do
          expect(policy.customisation_allowed?).to be_falsy
        end
      end

      context 'when discounted' do
        let(:discount) { no_discount }
        it do
          expect(policy.customisation_allowed?).to be_truthy
        end
      end
    end
  end
end

