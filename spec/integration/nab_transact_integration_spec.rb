require 'spec_helper'
#
# Test Direct Post and API Implementation
# -    Merchant ID (or "EPS_MERCHANT"): G9C0010
# -    Test Transaction Password: 3kbn8AO1
# nab test card = 4444333322221111

describe 'NABTransact' do
  context 'Fame Test Credentials' do
    let(:one_dollar) { 100 }

    let(:test_username) { 'G9C0010'  }
    let(:test_password) { '3kbn8AO1' }

    let(:order_reference_number) { '3682261795659690329' }


    let(:valid_test_card) {
      ActiveMerchant::Billing::CreditCard.new(
          :first_name => 'Fame',
          :last_name  => 'Babe',
          :month      => '9',
          :year       => '2016',
          :brand      => 'visa',
          :number     => '4444333322221111'
      )
    }
    let(:gateway) {
      ActiveMerchant::Billing::NabTransactGateway.new login: test_username, password: test_password, test: true
    }

    subject(:response) do
      gateway.purchase(one_dollar, valid_test_card, order_id: order_reference_number)
    end


    it 'can process test transactions' do
      expect(response.params['response_code']).to     eq '00'
      expect(response.params['response_text']).to     eq 'Approved'
      expect(response.params['merchant_id']).to       eq test_username
      expect(response.params['amount']).to            eq one_dollar.to_s
      expect(response.params['purchase_order_no']).to eq order_reference_number
      expect( Date.strptime(response.params['settlement_date'], "%Y%m%d")).to be_within(1.day).of(Date.today)
    end
  end
end