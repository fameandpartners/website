require 'spec_helper'

RSpec.describe VariantSku do
  let(:style_number)  { 'OMGWTFBBQ' }
  let(:dress)         { create :dress, sku: style_number }

  describe 'new SKUs' do
    let(:sku_generator) { described_class.new(variant) }

    subject(:sku)       { sku_generator.call  }

    context 'master variant' do
      let(:variant)       { dress.master }

      it "returns the master's sku" do
        expect(sku).to eq style_number
      end
    end

    context 'with variants' do
      let(:dress)   { create :dress_with_magenta_size_10, sku: style_number }
      let(:variant) { dress.variants.first }
      let(:colour_id) { Spree::OptionValue.where(:name => 'magenta').first.id.to_s }

      before :each do
        # I am so sick of these class variables causing stupid test failures.
        Spree::Variant.instance_variable_set(:@size_option_type, nil)
        Spree::Variant.instance_variable_set(:@color_option_type, nil)
      end

      it 'includes the style number' do
        expect(sku).to include(style_number)
      end

      it do
        expect(sku).to start_with 'OMGWTFBBQ-US10AU14'
      end

      it 'includes the colour id' do
        expect(sku).to end_with("C#{colour_id}")
      end

      it "includes the size name, without separating '/'" do
        expect(sku).to include('US10AU14')
      end
    end
  end

  xdescribe 'old SKUs' do
    subject(:sku)       { variant.generate_sku }

    context 'master variant' do
      let(:variant)       { dress.master }

      it "returns the master's sku" do
        expect(sku).to eq style_number
      end
    end

    context 'with variants' do
      let(:dress)   { create :dress_with_magenta_size_10, sku: style_number}
      let(:variant) { dress.variants.first }

      it 'includes the style number' do
        expect(sku).to include(style_number)
      end

      it 'includes the colour' do
        expect(sku).to include('Color:Magenta')
      end

      it "includes the size" do
        expect(sku).to include('US 10/AU 14')
      end

    end
  end
end
