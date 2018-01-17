require 'spec_helper'

# 11th January 2017: SKU Generation is now handled by the `Skus::Generator`. These tests are somehow duplicated

RSpec.describe VariantSku do
  let(:style_number)     { 'OmGWtFBBq' }
  let(:dress)            { create :dress, sku: style_number }

  describe 'new SKUs' do
    let(:sku_generator) { described_class.new(variant) }
    subject(:sku)       { sku_generator.call }

    context 'fallback on error' do
      let(:variant) { dress.master }

      before do
        allow_any_instance_of(described_class).to receive(:style_number).and_raise(StandardError)
      end

      it 'falls back to upcased variant SKU' do
        expect(sku).to eq('OMGWTFBBQ')
      end

      it 'reports to NewRelic and Sentry' do
        expect(Raven).to receive(:capture_exception).with(StandardError)
        expect(NewRelic::Agent).to receive(:notice_error).with(StandardError, variant_id: nil)

        sku_generator.call
      end
    end

    context 'master variant' do
      let(:variant)       { dress.master }

      it "returns the master's upcased sku" do
        expect(sku).to eq('OMGWTFBBQ')
      end
    end

    context 'with variants' do
      let(:dress)   { create :dress_with_magenta_size_10, sku: style_number }
      let(:variant) { dress.variants.first }
      let(:colour_id) { Spree::OptionValue.where(:name => 'magenta').first.id.to_s }

      it 'contains a complete SKU' do
        expect(sku).to eq "OMGWTFBBQUS10AU14C#{colour_id}XHSD"
      end

      it 'includes the style number' do
        expect(sku).to include('OMGWTFBBQ')
      end

      it 'includes the colour id' do
        expect(sku).to include("C#{colour_id}")
      end

      it "includes the size name, without separating '/'" do
        expect(sku).to include('US10AU14')
      end
    end

    # Regression for https://fameandpartners.atlassian.net/browse/WEBSITE-1314
    context 'without a size' do
      let(:color_magenta) { create(:product_colour, name: 'magenta', presentation: 'Magenta') }
      let(:variant) { create(:dress_variant, product: dress, option_values: [color_magenta]) }

      it { expect(sku).to include('OMGWTFBBQ') }
    end
  end
end
