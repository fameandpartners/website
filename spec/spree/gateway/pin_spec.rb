require 'spec_helper'

describe Spree::Gateway::Pin do
  subject(:gateway) { described_class.new }

  describe '#currency' do
    context 'currency preference is setup' do
      before(:each) { gateway.preferred_currency = 'BRL' }

      it 'returns setup currency' do
        expect(gateway.currency).to eq('BRL')
      end
    end

    context 'currency preference is not setup' do
      before(:each) { gateway.preferred_currency = nil }

      it 'returns default USD value' do
        expect(gateway.currency).to eq('USD')
      end
    end
  end
end
