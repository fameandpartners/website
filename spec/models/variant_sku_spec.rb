require 'spec_helper'

RSpec.describe VariantSku do

  let(:style_number)  { 'OMGWTFBBQ'  }
  let(:dress)         { create :dress, sku: style_number }
  let(:variant)       { dress.master }
  let(:sku_generator) { described_class.new(variant) }


  describe 'existing SKUs' do
    subject(:sku)       { variant.generate_sku  }

    context 'master variant' do
      it "returns the master's sku" do
        expect(sku).to eq style_number
      end
    end

    context 'with variants' do
      let(:dress)   { create :dress_with_variants, sku: style_number}

      subject(:variant_skus) {
        dress.variants.map {|variant| variant.generate_sku }
      }

      it 'includes the style number' do
        expect(variant_skus[0]).to include(style_number)
        expect(variant_skus[1]).to include(style_number)
        expect(variant_skus[2]).to include(style_number)
      end

      it 'includes the colour' do
        expect(variant_skus[0]).to include('Color:Red')
        expect(variant_skus[1]).to include('Color:Red')
        expect(variant_skus[2]).to include('Color:Red')
      end

      xit "includes the size"

    end
  end
end
