require 'spec_helper'

describe Spree::Calculator::CalifornianTaxRate do
  # Note: tax rates are associated with zones. We need to create countries before proceeding
  let!(:usa) { create(:country, iso3: 'USA') }
  let!(:brazil) { create(:country, iso3: 'BRA') }
  let!(:global_zone) { create(:global_zone) }

  let!(:calculator) { described_class.new }
  let!(:rate) { create(:tax_rate, zone: global_zone, calculator: described_class.new, amount: 0.075) }
  let!(:shipping_method) { FactoryGirl.create(:simple_shipping_method) }

  let!(:line_item) do
    FactoryGirl.create(:dress_item, price: 123.45, quantity: 1) 
  end
  let!(:order) { line_item.order }

  before(:each) do
    order.shipping_method = shipping_method
    order.ship_address = ship_address
    order.save!

    order.create_tax_charge!
    order.updater.update
  end

  context 'given an order from USA' do
    context 'from California' do
      let!(:california) { create(:state, name: 'California', country: usa) }
      let!(:ship_address) { build(:address, country: usa, state: california) }

      it 'adds configured rate amount of tax to the order total' do
        expect(order.reload.total).to eq(132.71)
      end
    end

    context 'outside California' do
      let!(:texas) { create(:state, name: 'Texas', country: usa) }
      let!(:ship_address) { build(:address, country: usa, state: texas) }

      it 'does not add any tax to the order total' do
        expect(order.reload.total).to eq(123.45)
      end
    end
  end

  context 'given an order outside USA' do
    let!(:rio_de_janeiro) { create(:state, name: 'Rio de Janeiro', country: brazil) }
    let!(:ship_address) { build(:address, state: rio_de_janeiro, country: brazil) }

    it 'does not add any tax to the order total' do
      expect(order.reload.total).to eq(123.45)
    end
  end
end
