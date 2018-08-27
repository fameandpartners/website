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
      end

      context 'when discounted by sales with allowed customisations discount' do
        let(:discount) { customisable_discount }

        it('allows customisation') do
          expect(product.customizable?).to be_truthy
        end
      end

      context 'at full price' do
        let(:discount) { no_discount }

        it('allows customisation') do
          expect(product.customizable?).to be_truthy
        end
      end
    end

    describe 'sizing chart' do
      subject(:product) { described_class.new size_chart: size_chart }

      describe '#size_chart' do
        let(:size_chart)  { 'TEENYTINY' }

        it { expect(product.size_chart).to eq(size_chart) }
      end
    end

    describe '#meta_description' do
      let(:spree_price) { Spree::Price.new(amount: 12.34, currency: 'AUD') }

      subject(:product) do
        described_class.new price: spree_price, name: 'Devan', fabric: '100% polyester light georgette. With Super long description'*10
      end

      context 'when product meta description is not present' do
        it 'returns truncated version of its meta title, price with currency and fabric description' do
          result = product.meta_description
          expect(result).to eq('Devan Dress. $12.34 AUD. 100% polyester light georgette. With Super long description100% polyester light georgette. With Super long description100% polyester...')
          expect(result.size).to eq(described_class::META_DESCRIPTION_MAX_SIZE)
        end
      end

      context 'when product meta description is present' do
        before(:each) { product.meta_description = 'My Super Meta Description Which is Truncated '*10 }

        it 'usees its truncated meta description field' do
          result = product.meta_description
          expect(result).to eq('My Super Meta Description Which is Truncated My Super Meta Description Which is Truncated My Super Meta Description Which is Truncated My Super Meta Descript...')
          expect(result.size).to eq(described_class::META_DESCRIPTION_MAX_SIZE)
        end
      end
    end

    describe '#height_customisable? coerces to boolean' do
      subject(:product) { described_class.new height_customisable: height_customisable }

      context do
        let(:height_customisable) { nil }
        it { is_expected.to_not be_height_customisable }
      end

      context do
        let(:height_customisable) { "whatever" }
        it { is_expected.to be_height_customisable }
      end
    end

    describe '#price_amount' do
      let(:currency) { 'AUD' }
      let(:price)   { Spree::Price.new(amount: 15.0, currency: currency) }
      let(:product) { described_class.new price: price }

      context 'product has discount' do
        before :each do
          allow(Spree::Sale).to receive(:last_sitewide_for).and_return(double(Spree::Sale, apply: new_price, discount_size: 10, discount_string: "10%"))
        end
        let(:new_price) { Spree::Price.new(amount: 13.5, currency: currency) }

        it 'returns the amount of the product price with the discount' do
          expect(product.price_amount).to eq(new_price.amount)
        end
      end

      context 'product does not have a discount' do
        it 'returns the full amount of the product price' do
          expect(product.price_amount).to eq(price.amount)
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

    describe ':fast_making_disabled? overiddes product values' do

      let(:fast_making_option) { ProductMakingOption.new(option_type: "fast_making") }
      let(:other_option)       { ProductMakingOption.new(option_type: Faker::Name.name) }
      let(:available_options)  { double('available_options', making_options: [fast_making_option, other_option]) }

      subject(:product)        { described_class.new(available_options: available_options, fast_making: true) }

      context 'fast_making is disabled' do
        before do
          allow(product).to receive(:fast_making_disabled?).and_return(true)
        end

        it { expect(product.making_options).to_not include(fast_making_option) }
        it { expect(product.fast_making).to        eq(false) }
      end

      context 'fast_making is enabled' do
        before do
          allow(product).to receive(:fast_making_disabled?).and_return(false)
        end

        it { expect(product.making_options).to include(fast_making_option) }
        it { expect(product.fast_making).to    eq(true) }
      end
    end

    describe '#fast_making_disabled? mirrors Feature :getitquick_unavailable' do
      let(:product) { described_class.new({}) }

      it 'when active' do
        Features.activate(:getitquick_unavailable)

        expect(product.fast_making_disabled?).to be_truthy
      end

      it 'when disabled' do
        Features.deactivate(:getitquick_unavailable)

        expect(product.fast_making_disabled?).to be_falsey
      end
    end

    describe 'functions as a collection presenter (Products::Collection::Dress)' do
      let(:hash_keys)   { [:id, :name, :color, :images, :price, :discount, :fast_making, :fast_delivery] }
      let(:dummy_hash)  { hash_keys.zip(hash_keys.map(&:to_s)).to_h }
      let(:product)     { described_class.new(dummy_hash) }

      it { expect(product.to_h).to eq(dummy_hash) }
    end

    describe 'complete prices' do
      let(:site_version)   { build(:site_version, :us) }
      let(:first_variant)  { build(:dress_variant, sku: 'SKU123') }
      let(:second_variant) { build(:dress_variant, sku: 'SKU456') }
      let(:product)        { build(:dress, variants: [first_variant, second_variant], price: 100) }
      let(:presenter)      { described_class.new(product: product, price: product.site_price_for(site_version), discount: discount) }

      context 'without sale' do
        let(:discount) { nil }

        it 'returns only original price' do
          expect(presenter.prices).to include({
            original_amount: 100.0,
                sale_amount: nil,
            discount_amount: nil,
            original_string: '$100.00',
                sale_string: nil,
            discount_string: nil
          })
        end
      end

      context 'with sale' do
        let(:discount) { nil }
        let(:new_price) { Spree::Price.new(amount: 90) }

        before :each do
          allow(Spree::Sale).to receive(:last_sitewide_for).and_return(double(Spree::Sale, apply: new_price, discount_size: 10, discount_string: "10%"))
        end

        it 'returns price with sale' do
          expect(presenter.prices).to include({
            original_amount: 100.0,
                sale_amount: 90.0,
            discount_amount: 10,
            original_string: '$100.00',
                sale_string: '$90.00',
            discount_string: '10%'
          })
        end
      end
    end

  end
end
