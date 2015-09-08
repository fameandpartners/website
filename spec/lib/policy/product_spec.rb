require 'spec_helper'

module Policy
  describe Product do
    describe '#customisation_allowed?' do

      let(:default_discount)  { double('discount', customisation_allowed?: false) }
      let(:customisable_discount)  { double('discount', customisation_allowed?: true) }
      let(:no_discount) { nil }

      let(:product) { double('product', :discount => discount) }

      subject(:policy) do
        Policy::Product.new(product)
      end

      context 'when discounted' do
        let(:discount) { default_discount }
        it do
          expect(policy.customisation_allowed?).to be_falsy
        end
      end

      context 'when discounted by customisation allowing sale' do
        let(:discount) { customisable_discount }
        it do
          expect(policy.customisation_allowed?).to be_truthy
        end
      end

      context 'when not discounted' do
        let(:discount) { no_discount }
        it do
          expect(policy.customisation_allowed?).to be_truthy
        end
      end
    end
  end
end

