require 'spec_helper'

describe "Afterpay Merchant", :vcr do
  before :all do
    @api = Afterpay::SDK::Merchant::API.new
  end

  let(:new_order_data) {
    {
      totalAmount: {
        amount: 319,
        currency: 'AUD'
      },
      consumer: {
        givenNames: 'Fame',
        surname: 'Partners',
        email: 'dev@fameandpartners.com'
      },
      merchant: {
        redirectConfirmUrl: 'https://192.168.1.141:3000/dresses',
        redirectCancelUrl: 'https://192.168.1.141:3000/dresses'
      }
    }
  }
  
  context 'configuration' do
    it 'should be readable' do
      get_configuration_response = @api.configuration

      expect(get_configuration_response).to be_a_kind_of(Array)
      expect(get_configuration_response[0].keys).to contain_exactly('type', 'description', 'maximumAmount')
    end
  end

  context 'direct payment flow' do
    it 'should be approved' do
      create_order_response = @api.create_order(new_order_data, { 'Use-VCR' => 'true' })
      get_order_response = @api.get_order({ token: create_order_response.fetch('token') }, { 'Use-VCR' => 'true' })
      new_payment_response = @api.direct_capture_payment(token: create_order_response.fetch('token'))

      expect(create_order_response).to be_a_kind_of(Hash)
      expect(create_order_response.keys).to contain_exactly('token', 'expires')

      expect(get_order_response).to be_a_kind_of(Hash)
      expect(get_order_response.keys).to contain_exactly('token', 'expires', 'totalAmount', 'consumer', 'items', 'merchant', 'courier', 'discounts', 'paymentType')

      expect(new_payment_response).to be_a_kind_of(Hash)
      expect(new_payment_response.keys).to contain_exactly('id', 'token', 'refunds', 'merchantReference', 'created', 'status', 'totalAmount', 'events', 'orderDetails')
      expect(new_payment_response['status']).to eq('APPROVED')
      expect(new_payment_response['token']).to eq(get_order_response['token'])
      expect(new_payment_response['totalAmount']['amount']).to eq(get_order_response['totalAmount']['amount'])
      expect(new_payment_response['orderDetails']['consumer']['email']).to eq(get_order_response['consumer']['email'])
    end
  end

  context 'authorization and capture payment flow' do
    it 'should be authorized and approved' do
      create_order_response = @api.create_order(new_order_data, { 'Use-VCR' => 'true' })
      get_order_response = @api.get_order({ token: create_order_response.fetch('token') }, { 'Use-VCR' => 'true' })
      authorize_payment_response = @api.authorize_payment(token: create_order_response.fetch('token'))
      capture_payment_response = @api.capture_payment(payment_id: authorize_payment_response.fetch('id'))

      expect(create_order_response).to be_a_kind_of(Hash)
      expect(create_order_response.keys).to contain_exactly('token', 'expires')

      expect(get_order_response).to be_a_kind_of(Hash)
      expect(get_order_response.keys).to contain_exactly('token', 'expires', 'totalAmount', 'consumer', 'items', 'merchant', 'courier', 'discounts', 'paymentType')

      expect(authorize_payment_response).to be_a_kind_of(Hash)
      expect(authorize_payment_response.keys).to contain_exactly('id', 'created', 'status', 'merchantReference', 'totalAmount', 'events', 'orderDetails', 'token', 'refunds')
      expect(authorize_payment_response['status']).to eq('APPROVED')
      expect(authorize_payment_response['totalAmount']['amount']).to eq(get_order_response['totalAmount']['amount'])
      expect(authorize_payment_response['orderDetails']['consumer']['email']).to eq(get_order_response['consumer']['email'])
      expect(capture_payment_response).to be_a_kind_of(Hash)
      expect(capture_payment_response.keys).to contain_exactly('id', 'created', 'status', 'merchantReference', 'totalAmount', 'events', 'orderDetails', 'token')
      expect(capture_payment_response['status']).to eq('APPROVED')
      expect(capture_payment_response['totalAmount']['amount']).to eq(get_order_response['totalAmount']['amount'])
      expect(capture_payment_response['orderDetails']['consumer']['email']).to eq(get_order_response['consumer']['email'])
    end
  end

end
