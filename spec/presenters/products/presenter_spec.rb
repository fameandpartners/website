require 'spec_helper'

module Products
  describe Presenter do
    describe 'customisations' do
      let(:a_discount)  { 999 }
      let(:no_discount) { nil }
      let(:customizations) { double('customizations', :all => [:some]) }
      let(:colors)         { double('custom_colours', :extra => [:some]) }
      let(:available_options) do
        double('available_options', :customizations => customizations, :colors => colors)
      end
      subject(:product) do
        Presenter.new available_options: available_options, discount: discount
      end

      context 'when discounted' do
        let(:discount) { a_discount }

        it('disallows customisation') do
          expect(product.customizable?).to be_falsy
        end

        it('disallows custom colours') do
          expect(product.custom_colors?).to be_falsy
        end

      end

      context 'at full price' do
        let(:discount) { no_discount }

        it('allows customisation') do
          expect(product.customizable?).to be_truthy
        end

        it('allows custom colours') do
          expect(product.custom_colors?).to be_truthy
        end
      end
    end
  end
end
