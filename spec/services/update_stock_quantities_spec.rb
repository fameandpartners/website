require 'spec_helper'

describe UpdateStockQuantites do
  context "empty data" do
    it 'works' do
      expect(UpdateStockQuantites.new.process).to be true
    end
  end

  context "product finding by sku" do
    let(:product)    { create(:dress) }
    let!(:variant)    { create(:spree_variant, product_id: product.id, sku: 'my-test-sku') }
    let(:subject)    { UpdateStockQuantites.new }

    it 'return product by exact match' do
      expect(subject.send(:product_by_sku, variant.sku).try(:id)).to eq(product.id)
    end

    it 'return product by beginning' do
      expect(subject.send(:product_by_sku, 'my-test').try(:id)).to eq(product.id)
    end

    it 'case-insensitive' do
      variant.update_column(:sku, variant.sku.upcase)
      expect(subject.send(:product_by_sku, 'mY-TeSt').try(:id)).to eq(product.id)
    end
  end

  # external dependencies:
  #   Products::VariantsReceiver.
  #   product_by_sku
  #
  context "service" do
    let(:product)     { create(:dress, on_demand: true) }
    let!(:variant)    { 
      create(:spree_variant, product_id: product.id, sku: 'my-test-sku', on_demand: true, count_on_hand: 0)
    }

    it 'updates quantity for given variants' do
      stock_variant_details = FastOpenStruct.new(sku: variant.sku, colour: 'black', size: 15, quantity: 10)
      subject = UpdateStockQuantites.new([stock_variant_details])

      allow_any_instance_of(Products::VariantsReceiver).to receive(:available_options).and_return([{
        id: variant.id,
        size_presentation: stock_variant_details.size,
        color_presentation: stock_variant_details.colour
      }])

      subject.process

      expect(Spree::Product.find(product.id).on_demand).to be false
      expect(Spree::Product.find(product.id).count_on_hand).to eq(stock_variant_details.quantity)

      expect(Spree::Variant.find(variant.id).on_demand).to be false
      expect(Spree::Variant.find(variant.id).count_on_hand).to eq(stock_variant_details.quantity)
    end

    it 'resets other products & variants' do
      # set products as non empty
      variant.update_column(:count_on_hand, 5)
      variant.update_attributes(on_demand: false)
      product.update_attributes(on_demand: false)

      # incoming data doen't contain any info about this products
      stock_variant_details = FastOpenStruct.new(sku: variant.sku, colour: 'black', size: 15, quantity: 10)
      subject = UpdateStockQuantites.new([stock_variant_details])

      allow_any_instance_of(Products::VariantsReceiver).to receive(:available_options).and_return([])

      subject.process

      # validate reseting
      expect(Spree::Product.find(product.id).on_demand).to be true
      expect(Spree::Product.find(product.id).count_on_hand).to eq(0)

      expect(Spree::Variant.find(variant.id).on_demand).to be true
      expect(Spree::Variant.find(variant.id).count_on_hand).to eq(0)
    end
  end
end
