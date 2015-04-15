require 'spec_helper'

describe CreditCardGatewayService do

  let(:usd)     { double(Spree::Gateway::Pin, :currency => 'USD', :method_type => 'gateway') }
  let(:aud)     { double(Spree::Gateway::Pin, :currency => 'AUD', :method_type => 'gateway') }
  let(:order)   { double(Spree::Order, :available_payment_methods => [usd, aud]) }

  let(:service) { CreditCardGatewayService.new(order, currency) }

  context 'disabled' do
    let(:currency) { 'USD' }

    before do
      allow(Features).to receive(:active?).and_return(false)
    end

    it 'should return the correct gateway' do
      expect(service.gateway).to eq aud
    end
  end

  context 'USD' do
    let(:currency) { 'USD' }

    before do
      allow(Features).to receive(:active?).and_return(true)
    end

    it 'should return the correct gateway' do
      expect(service.gateway).to eq usd
    end
  end

  context 'AUD' do
    let(:currency) { 'AUD' }

    before do
      allow(Features).to receive(:active?).and_return(true)
    end

    it 'should return the correct gateway' do
      expect(service.gateway).to eq aud
    end
  end

end
