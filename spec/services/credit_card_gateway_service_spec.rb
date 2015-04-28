require 'spec_helper'

describe CreditCardGatewayService do

  let(:usd)     { double(Spree::Gateway::Pin, :currency => 'USD', :method_type => 'gateway') }
  let(:aud)     { double(Spree::Gateway::Pin, :currency => 'AUD', :method_type => 'gateway') }
  let(:order)   { double(Spree::Order, :available_payment_methods => [aud, usd]) }

  let(:service) { CreditCardGatewayService.new(order, currency) }

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
    let(:order)   { double(Spree::Order, :available_payment_methods => [aud]) }
    let(:currency) { 'USD' }

    it 'should return the correct gateway' do
      expect(service.gateway).to eq aud
    end
  end

end
