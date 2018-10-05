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

      RSpec::Matchers.define :include_price do |expected_currency, expected_value|
        match do |actual|
          actual.any? { |price|
            price.currency == expected_currency && price.amount == expected_value
          }
        end

        failure_message do |actual|
          values = actual.collect do |price|
            [price.currency, price.amount].join(' ')
          end.join(', ')

          "expected that [#{values}] would include #{expected_currency} #{expected_value}"
        end
      end

      let(:original_amount)  { 33 }
      let(:new_aud_amount)   { 43 }
      let(:new_usd_amount)   { 177 }

      let(:product)          { create(:spree_product, price: original_amount) }
      let(:master)           { product.master }
      let(:variant)          { create(:spree_variant, product: product, price: aud_master_price.amount) }

      let(:aud_master_price) { create(:price, variant: master, amount: original_amount, currency: 'AUD') }
      let(:usd_master_price) { create(:price, variant: master, amount: original_amount, currency: 'USD') }

      before(:each) do
        # Guarantee that only aud_master_price and usd_master_price are the master prices
        master.prices = [aud_master_price, usd_master_price]
      end

      it 'creates new variant prices' do
        variant.prices.map(&:destroy)
        master.product.reload

        aud_master_price.amount = new_aud_amount
        usd_master_price.amount = new_usd_amount

        
        master.save
        variant.reload

        expect(variant.prices).to include_price('AUD', new_aud_amount)
        expect(variant.prices).to include_price('USD', new_usd_amount)
      end

      it 'normalises incorrect variant prices' do
        variant.prices.each { |price| price.update_attributes(amount: 0) }
        master.product.reload

        aud_master_price.amount = new_aud_amount
        usd_master_price.amount = new_usd_amount

        master.save
        variant.reload

        expect(variant.prices).to include_price('AUD', new_aud_amount)
        expect(variant.prices).to include_price('USD', new_usd_amount)
      end

      it 'saving non master variants does not touch master prices' do
        variant.prices.each { |price| price.amount = 555 }
        variant.save

        expect(master.prices).to include_price('AUD', original_amount)
        expect(master.prices).to include_price('USD', original_amount)
      end
    end
  end
end
