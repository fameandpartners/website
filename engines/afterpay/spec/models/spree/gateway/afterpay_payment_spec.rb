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
      it { expect(payment_method.provider_class).to eq(::Afterpay::SDK::Merchant) }
      it { expect(payment_method.provider).to be_an_instance_of(::Afterpay::SDK::Merchant::API) }
      it { expect(payment_method.currency).to eq('AUD') }
      it { expect(payment_method.method_type).to eq('afterpay') }
    end

    describe 'Payment Actions' do
      describe 'completes a purchase' do
        let(:spree_credit_card) { Spree::CreditCard.new(gateway_payment_profile_id: 'Magical Number!') }

        it 'calls active merchant billing method' do
          expect(ActiveMerchant::Billing::Response).to receive(:new).with(true, 'AfterPay Gateway: Success', {}, authorization: 'Magical Number!')

          payment_method.purchase('amount', spree_credit_card)
        end
      end

      it 'refunds a purchase' do
        skip 'TODO. Will it ever be implemented?'
      end
    end
  end
end
