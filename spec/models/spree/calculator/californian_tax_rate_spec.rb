require 'spec_helper'

describe Spree::Calculator::CalifornianTaxRate do
  # Note: tax rates are associated with zones. We need to create countries before proceeding
  let!(:usa) { create(:country, iso3: 'USA') }
  let!(:brazil) { create(:country, iso3: 'BRA') }
  let!(:global_zone) { create(:global_zone) }

  let!(:calculator) { described_class.new }
  let!(:rate) { create(:tax_rate, zone: global_zone, calculator: described_class.new, amount: 0.075) }

  let!(:order) { create(:spree_order, ship_address: ship_address) }
  let!(:line_item) { build(:line_item, price: 123.45, quantity: 1) }

  # Very strange, but Spree uses this trick: https://github.com/spree/spree/blob/7d19c8933042cec667634c8cffedcbe6084abf1d/core/spec/models/calculator/default_tax_spec.rb#L17
  # It's avoiding a bunch of ActiveRecord callbacks
  before(:each) { allow(order).to receive(:line_items).and_return([line_item]) }

  context 'given an order from USA' do
    context 'from California' do
      let!(:california) { create(:state, name: 'California', country: usa) }
      let!(:ship_address) { build(:address, country: usa, state: california) }

      it 'adds configured rate amount of tax to the order total' do
        order.create_tax_charge!
        order.updater.update
        expect(order.reload.total).to eq(132.71)
      end
    end

    context 'outside California' do
      let!(:texas) { create(:state, name: 'Texas', country: usa) }
      let!(:ship_address) { build(:address, country: usa, state: texas) }

      it 'does not add any tax to the order total' do
        order.create_tax_charge!
        order.updater.update
        expect(order.reload.total).to eq(123.45)
      end
    end
  end

  context 'given an order outside USA' do
    let!(:rio_de_janeiro) { create(:state, name: 'Rio de Janeiro', country: brazil) }
    let!(:ship_address) { build(:address, state: rio_de_janeiro, country: brazil) }

    it 'does not add any tax to the order total' do
      order.create_tax_charge!
      order.updater.update
      expect(order.reload.total).to eq(123.45)
    end
  end
end
