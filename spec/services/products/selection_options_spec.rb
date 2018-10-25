require 'spec_helper'

module Products
  RSpec.describe SelectionOptions do
    subject(:selection_options) { described_class.new(product: product) }

    context 'color options' do
      let(:color_customizable_product)     { double('Product', discount: nil, color_customization: true) }
      let(:non_color_customizable_product) { double('Product', discount: nil, color_customization: false) }

      describe 'custom colors are not allowed' do
        let(:product) { non_color_customizable_product }

        it { expect(subject.send(:extra_colors_available?)).to be_falsey }
        it { expect(subject.send(:extra_product_colors)).to eq([]) }
      end

      describe 'custom colors are allowed' do
        let(:product) { color_customizable_product }

        subject(:available_colors)  { selection_options.send(:extra_product_colors) }

        let(:defined_custom_colors)  { double(:defined_custom_colors) }
        let(:fallback_custom_colors) { double(:fallback_custom_colors) }
        before do
          allow(selection_options).to receive(:defined_custom_colors).and_return(defined_custom_colors)
        end

        context 'colors are defined for a product' do
          it 'returns the defined colors' do
            is_expected.to eq defined_custom_colors
          end
        end

        context 'colors are not defined' do
          let(:defined_custom_colors) { [] }
          it 'falls back to using the full list of custom colors' do
            is_expected.to eq []
          end
        end
      end
    end

  end
end
