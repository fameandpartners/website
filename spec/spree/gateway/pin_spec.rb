require 'spec_helper'

describe Spree::Gateway::Pin do

  let(:gateway) { Spree::Gateway::Pin.new }

  context 'US' do

    before do
      expect(gateway).to receive(:preferred_publishable_key).and_return('obtain-test-gateway-from-mngr')
    end

    it 'USD gateway' do
      expect(gateway.currency).to eq 'USD'
    end
  end

  context 'AUD' do

    before do
      expect(gateway).to receive(:preferred_publishable_key).and_return('anything-else-does-not-matter')
    end

    it 'USD gateway' do
      expect(gateway.currency).to eq 'AUD'
    end

  end


end
