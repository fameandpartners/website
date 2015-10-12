require 'spec_helper'

describe Spree::Variant, :type => :model do
  context "new product" do
    let(:subject) { Spree::Variant.new }

    it "should be on demand" do
      expect(subject.on_demand).to be true
    end

    it "should have non-zero amount" do
      expect(subject.count_on_hand).to be > 0
    end
  end

  context "fast_delivery" do
    let(:subject) { Spree::Variant.new }

    it "true for existing items on stock" do
      subject.on_demand     = false
      subject.count_on_hand = 5

      expect(subject.fast_delivery?).to be true
    end

    it "false for 0 quantity on stock" do
      subject.on_demand     = false
      subject.count_on_hand = 0

      expect(subject.fast_delivery?).to be false
    end

    it "false if product on demand" do
      subject.on_demand = true
      subject.count_on_hand = 5
      expect(subject.fast_delivery?).to be false
    end
  end

  context "before save" do

    # if master variant update it's prices, then all default (inherited from master) prices
    # should be accordingly updated
    context '#push_prices_to_variants' do
      let(:product) { create(:dress) }
      let(:master)  { product.master }
      let(:variant) { create(:spree_variant, product: product, price: master_price.amount) }
      let(:master_price)    { product.master.prices.first }
      let(:variant_price)   { variant.prices.first }
      let(:original_amount) { master_price.amount }
      let(:new_amount)      { original_amount + 10 }

      it 'creates new variant prices' do
        variant_price.destroy
        master_price.update_attributes(amount:  new_amount)
        master.reload

        master.save

        expect(variant.reload.prices.first.amount).to eq new_amount
      end

      it 'normalises incorrect variant prices' do
        variant_price.update_attributes(amount:  555)
        master_price.update_attributes(amount:  new_amount)
        master.reload

        master.save

        expect(variant.prices.first.amount).to eq new_amount
        expect(master.prices.first.amount).to  eq new_amount
      end

      it 'updates existing variant prices' do
        master_price.update_attributes(amount:  new_amount)
        master.reload

        master.save
        expect(variant_price.amount).to eq new_amount
      end

      it 'doesnt touch master prices' do
        variant_price.update_attributes(amount:  new_amount)

        variant.save

        expect(variant.prices.first.amount).to eq new_amount
        expect(master.prices.first.amount).to  eq original_amount
      end
    end
  end
end
