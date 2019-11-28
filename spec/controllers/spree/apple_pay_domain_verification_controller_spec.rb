require 'spec_helper'
require 'securerandom'

describe 'Apple Pay Domain Verification', type: :request do
  let(:domain_verification_certificate) { SecureRandom.hex(20) }
  let(:stripe_apple_pay_payment_method) do
    Spree::Gateway::ApplePayStripe.create!(
      name: 'ApplePay',
      preferred_domain_verification_certificate: domain_verification_certificate
    )
  end
  let(:execute) { get '/.well-known/apple-developer-merchantid-domain-association' }

  shared_examples 'returns 404' do
    it 'returns RecordNotFound exception' do
      execute
      expect(response.status).to eq(404)
    end
  end

  context 'apple pay gateway exists' do
    before do
      stripe_apple_pay_payment_method
      execute
    end

    it 'payment method created success' do
      expect(stripe_apple_pay_payment_method.name).to eq 'ApplePay'
      expect(stripe_apple_pay_payment_method.active?).to eq true
    end

    it 'returns 200 HTTP status' do
      expect(response.status).to eq(200)
    end

    it 'renders domain verification certificate' do
      expect(response.body).to eq domain_verification_certificate
    end
  end

  context 'apple pay gateway doesnt exist' do
    it_behaves_like 'returns 404'
  end

  context 'apple pay gateway not active' do
    before do
      stripe_apple_pay_payment_method.update_column(:active, false)
    end

    it_behaves_like 'returns 404'
  end
end
