require 'spec_helper'
#
# Test Direct Post and API Implementation
# -    Merchant ID (or "EPS_MERCHANT"): G9C0010
# -    Test Transaction Password: 3kbn8AO1
# nab test card = 4444333322221111

describe 'NABTransact' do
  context 'Fame Test Credentials' do
    # This just lets us track test transactions a bit easier in the NAB interface.
    let(:whodunnit) { "#{ENV['USER']}@#{Socket.gethostname}-#{Process.pid}" }

    let(:purchase_amount) { 101 }
    let(:order_reference) { "#{gateway_slug}-#{whodunnit}" }
    let(:test_username)   { 'G9C0010'  }
    let(:test_password)   { '3kbn8AO1' }
    let(:test_mode)       { true }
    let(:currency)        { 'AUD' }

    let(:visa_test_card) {
      ActiveMerchant::Billing::CreditCard.new(
          :first_name => 'Fame',
          :last_name  => 'Babe',
          :month      => '9',
          :year       => 3.years.from_now.year.to_s,
          :brand      => 'visa',
          :number     => '4444333322221111',
          :verification_value => '123'
      )
    }

    subject(:response) do
      gateway.purchase(purchase_amount, visa_test_card, order_id: order_reference, currency: currency)
    end

    shared_examples :processes_test_transactions do
      it 'processes a test transaction' do
        expect(response.params['response_code']).to     eq '00'
        expect(response.params['response_text']).to     eq 'Approved'
        expect(response.params['merchant_id']).to       eq test_username
        expect(response.params['amount']).to            eq purchase_amount.to_s
        expect(response.params['currency']).to          eq currency
        expect(response.params['purchase_order_no']).to eq order_reference
        expect( Date.strptime(response.params['settlement_date'], "%Y%m%d")).to be_within(1.day).of(Date.today)
      end
    end

    context ActiveMerchant::Billing::NabTransactGateway do
      let(:gateway_slug) { "AM:B:NTGW" }

      let(:gateway) {
        ActiveMerchant::Billing::NabTransactGateway.new(
            login:    test_username,
            password: test_password,
            test:     test_mode
        )
      }

      context 'AUD' do
        let(:currency) { 'AUD' }
        include_examples :processes_test_transactions
      end

      context 'USD' do
        let(:currency) { 'USD' }
        include_examples :processes_test_transactions
      end
    end

    context Spree::Gateway::NabTransactGateway do
      let(:gateway_slug) { "S:G:NTGW" }

      let(:gateway) {
        Spree::Gateway::NabTransactGateway.new(
            preferred_login:     test_username,
            preferred_password:  test_password,
            preferred_test_mode: test_mode
        )
      }

      context 'AUD' do
        let(:currency) { 'AUD' }
        include_examples :processes_test_transactions
      end

      context 'USD' do
        let(:currency) { 'USD' }
        include_examples :processes_test_transactions
      end
    end
  end
end
