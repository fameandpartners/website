require 'spec_helper'

module Products
  describe Presenter do
    describe 'customisations' do
      let(:spree_price)           { Spree::Price.new(amount: 99, currency: 'USD') }
      let(:default_discount)      { double('discount', customisation_allowed: false) }
      let(:customisable_discount) { double('discount', customisation_allowed: true) }
      let(:no_discount)           { nil }
      let(:customizations)        { double('customizations', :all => [:some]) }
      let(:colors)                { double('custom_colours', :extra => [:some]) }
      let(:available_options) do
        double('available_options', :customizations => customizations, :colors => colors)
      end

      subject(:product) do
        described_class.new available_options: available_options, discount: discount, price: spree_price
      end

      context 'when discounted' do
        let(:discount) { default_discount }

        it('disallows customisation') do
          expect(product.customizable?).to be_falsy
        end

        it('disallows custom colours') do
          expect(product.custom_colors?).to be_falsy
        end

      end

      context 'when discounted by sales with allowed customisations discount' do
        let(:discount) { customisable_discount }

        it('allows customisation') do
          expect(product.customizable?).to be_truthy
        end

        it('allows custom colours') do
          expect(product.custom_colors?).to be_truthy
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

        it 'displays price with currency' do
          expect(product.price_with_currency).to include('$99.00 USD')
        end
      end
    end

    describe 'sizing chart' do
      subject(:product) { described_class.new size_chart: size_chart }

      describe '#size_chart' do
        let(:size_chart)  { 'TEENYTINY' }

        it { expect(product.size_chart).to eq(size_chart) }
      end

      describe '#size_chart_explanation' do

        describe 'old (2014) chart' do
          let(:size_chart) { '2014' }

          it do
            expect(product.size_chart_explanation).to eq(
              'This dress follows our old measurements.'
            )
          end

          it { expect(product.size_chart_data).to eq SizeChart::SIZE_CHART_2014 }
        end

        describe 'new (2015) chart' do
          let(:size_chart) { '2015' }

          it do
            expect(product.size_chart_explanation).to eq(
                'We have updated our sizing! This dress follows our new size chart.'
            )
          end
          it { expect(product.size_chart_data).to eq SizeChart::SIZE_CHART_2015 }
        end

        describe 'unknown' do
          let(:size_chart) { '2016' }
          it { expect(product.size_chart_explanation).to eq '' }
          it { expect(product.size_chart_data).to eq SizeChart::DEFAULT_CHART }
        end
      end
    end

    describe '#meta_description' do
      let(:spree_price) { Spree::Price.new(amount: 12.34, currency: 'AUD') }

      subject(:product) do
        described_class.new price: spree_price, color_name: 'Golden', name: 'Devan', fabric: '100% polyester light georgette. With Super long description'*10
      end

      it 'returns truncated version of its meta title, price with currency and fabric description' do
        result = product.meta_description
        expect(result).to eq('Golden Devan Dress. $12.34 AUD. 100% polyester light georgette. With Super long description100% polyester light georgette. With Super long description100% po...')
        expect(result.size).to eq(Products::Presenter::META_DESCRIPTION_MAX_SIZE)
      end
    end

    describe '#price_amount' do
      let(:price)   { Spree::Price.new(amount: 15.0, currency: 'AUD') }
      let(:product) { described_class.new price: price, discount: discount }

      context 'product has discount' do
        let(:discount) { OpenStruct.new(amount: 10, size: 10) }

        it 'returns the amount of the product price with the discount' do
          expect(product.price_amount).to eq(13.5)
        end
      end

      context 'product does not have a discount' do
        let(:discount) { nil }

        it 'returns the full amount of the product price' do
          expect(product.price_amount).to eq(15)
        end
      end

      context 'product has a discount with 0 amount' do
        let(:discount) { OpenStruct.new(amount: 0, size: 0) }

        it 'returns the full amount of the product price' do
          expect(product.price_amount).to eq(15)
        end
      end
    end

    describe '#schema_availability' do
      context 'product is not available' do
        let(:product) { described_class.new is_active: false }

        it 'returns schema.org discontinued enumerator' do
          expect(product.schema_availability).to eq(Products::Presenter::SCHEMA_ORG_DISCONTINUED)
        end
      end

      context 'product is availalbe' do
        let(:product) { described_class.new is_active: true }

        it 'returns schema.org in stock enumerator' do
          expect(product.schema_availability).to eq(Products::Presenter::SCHEMA_ORG_IN_STOCK)
        end
      end
    end
  end
end
