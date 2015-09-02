require 'spec_helper'

# if master variant update it's prices, then all default (inherited from master) prices
# should be accordingly updated

describe Spree::Variant, :type => :model do
  let(:product) { create(:dress) }
  let(:master)  { product.master }
  let(:variant) { create(:spree_variant, product: product, price: master_price.amount) }
  let(:master_price)  { product.master.prices.first }
  let(:variant_price) { variant.prices.first }
  let(:amount)        { master_price.amount + 10 }

  context "push_changed_prices_to_variants" do
    it 'creates variant prices if not exists' do
      variant_price.destroy
      master.reload
      master.update_attributes(prices_attributes: { '0' => { price: amount, id: master_price.id }})
      expect(Spree::Price.where(variant_id: variant.id).first.amount).to eq(amount)
    end

    it 'updates variant price' do
      master.update_attributes(prices_attributes: { '0' => { price: amount, id: master_price.id }})
      expect(variant_price.amount).to eq(amount)
    end

    it "doesn't touch master prices" do
      variant.update_attributes(prices_attributes: { '0' => { price: amount, id: variant_price.id }})
      expect(variant.prices.first.amount).to  eq(amount)
      expect(master.prices.first.amount).not_to eq(amount)
    end
  end
end
