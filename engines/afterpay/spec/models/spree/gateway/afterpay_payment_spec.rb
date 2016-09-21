require 'spec_helper'

class Spree::Gateway
  RSpec.describe AfterpayPayment do
    subject(:payment_method) { described_class.new }

    describe 'preferences default values' do
      it { expect(payment_method.preferred_username).to eq('') }
      it { expect(payment_method.preferred_password).to eq('') }
    end

    describe 'Spree Gateway methods' do
      it { expect(payment_method.auto_capture?).to eq(true) }
      it { expect(payment_method.supports?({})).to eq(true) }
      it { expect(payment_method.provider_class).to eq(Spree::Gateway::Bogus) }
      it { expect(payment_method.currency).to eq('AUD') }
      it { expect(payment_method.method_type).to eq('afterpay') }
    end

    describe 'Payment Actions' do
      describe 'completes a purchase' do
        it 'calls active merchant billing method' do
          # For now, this is purely bogus
          expect(ActiveMerchant::Billing::Response).to receive(:new).with(true, 'Bogus Gateway: Forced success', {}, test: true, authorization: '12345', avs_result: { code: 'A' })

          payment_method.purchase('amount', 'transaction_details')
        end
      end

      it 'refunds a purchase' do
        skip 'TODO. Will it ever be implemented?'
      end
    end
  end
end
