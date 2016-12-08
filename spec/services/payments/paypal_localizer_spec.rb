require 'spec_helper'

describe Payments::PaypalLocalizer do
  let(:usd)     { double(Spree::Gateway::PayPalExpress, currency: 'USD', type: 'Spree::Gateway::PayPalExpress') }
  let(:aud)     { double(Spree::Gateway::PayPalExpress, currency: 'AUD', type: 'Spree::Gateway::PayPalExpress') }
  let(:order)   { double(Spree::Order, available_payment_methods: [aud, usd]) }

  subject(:service) { described_class.new(order, currency) }

  context 'USD' do
    let(:currency) { 'USD' }

    it 'should return the correct gateway' do
      expect(service.gateway).to eq usd
    end
  end

  context 'AUD' do
    let(:currency) { 'AUD' }

    it 'should return the correct gateway' do
      expect(service.gateway).to eq aud
    end
  end

  context 'with only AUD gateway and USD currency' do
    let(:order)   { double(Spree::Order, available_payment_methods: [aud]) }
    let(:currency) { 'USD' }

    it 'should return the correct gateway' do
      expect(service.gateway).to eq aud
    end
  end
end
