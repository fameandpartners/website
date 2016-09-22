require 'spec_helper'
require 'pry'

describe "Afterpay Merchant", :vcr do
  before :all do
    @api = Afterpay::SDK::Merchant::API.new
  end

  let(:get_configuration_response) { @api.configuration }
  let(:maximum_amount) { get_configuration_response[0]['maximumAmount']['amount'] }
  let(:new_order_data) {
    {
      totalAmount: {
        amount: rand(0..maximum_amount.to_i),
        currency: 'AUD'
      },
      consumer: {
        givenNames: 'Fame',
        surname: 'Partners',
        email: 'dev@fameandpartners.com'
      },
      merchant: {
        redirectConfirmUrl: 'https://localhost:3000/dresses',
        redirectCancelUrl: 'https://localhost:3000/dresses'
      }
    }
  }
  let(:order_token) { create_order_response['token'] }
  let(:create_order_response) { @api.create_order(new_order_data) }
  let(:get_order_response) { @api.get_order(token: order_token) }
  let(:new_payment_response) { @api.direct_capture_payment(token: order_token) }
  let(:authorize_payment_response) { @api.authorize_payment(token: order_token) }
  let(:capture_payment_response) { @api.capture_payment(payment_id: authorize_payment_response['id']) }

  context 'direct payment flow' do
    it 'configuration should be readable' do
      expect(get_configuration_response).to be_a_kind_of(Array)
      expect(get_configuration_response[0].keys).to contain_exactly('type', 'description', 'maximumAmount')
    end

    it 'order should be created and be able to read' do
      expect(create_order_response).to be_a_kind_of(Hash)
      expect(create_order_response.keys).to contain_exactly('token', 'expires')

      expect(get_order_response).to be_a_kind_of(Hash)
      expect(get_order_response.keys).to contain_exactly('token', 'expires', 'totalAmount', 'consumer', 'items', 'merchant', 'courier', 'discounts', 'paymentType')
    end

    it 'should be approved' do
      expect(new_payment_response).to be_a_kind_of(Hash)
      expect(new_payment_response.keys).to contain_exactly('id', 'token', 'refunds', 'merchantReference', 'created', 'status', 'totalAmount', 'events', 'orderDetails')
      expect(new_payment_response['status']).to eq('APPROVED')
      expect(new_payment_response['token']).to eq(get_order_response['token'])
      expect(new_payment_response['totalAmount']['amount']).to eq(get_order_response['totalAmount']['amount'])
      expect(new_payment_response['orderDetails']['consumer']['email']).to eq(get_order_response['consumer']['email'])
    end
  end

  context 'authorization and capture payment flow' do
    it 'configuration should be readable' do
      expect(get_configuration_response).to be_a_kind_of(Array)
      expect(get_configuration_response[0].keys).to contain_exactly('type', 'description', 'maximumAmount')
    end

    it 'order should be created and be able to read' do
      expect(create_order_response).to be_a_kind_of(Hash)
      expect(create_order_response.keys).to contain_exactly('token', 'expires')

      expect(get_order_response).to be_a_kind_of(Hash)
      expect(get_order_response.keys).to contain_exactly('token', 'expires', 'totalAmount', 'consumer', 'items', 'merchant', 'courier', 'discounts', 'paymentType')
    end

    it 'should be authorized' do
      expect(authorize_payment_response).to be_a_kind_of(Hash)
      expect(authorize_payment_response.keys).to contain_exactly('id', 'created', 'status', 'merchantReference', 'totalAmount', 'events', 'orderDetails', 'token', 'refunds')
      expect(authorize_payment_response['status']).to eq('APPROVED')
      expect(authorize_payment_response['totalAmount']['amount']).to eq(get_order_response['totalAmount']['amount'])
      expect(authorize_payment_response['orderDetails']['consumer']['email']).to eq(get_order_response['consumer']['email'])
    end

    it 'should be approved' do
      expect(capture_payment_response).to be_a_kind_of(Hash)
      expect(capture_payment_response.keys).to contain_exactly('id', 'created', 'status', 'merchantReference', 'totalAmount', 'events', 'orderDetails', 'token')
      expect(capture_payment_response['status']).to eq('APPROVED')
      expect(capture_payment_response['totalAmount']['amount']).to eq(get_order_response['totalAmount']['amount'])
      expect(capture_payment_response['orderDetails']['consumer']['email']).to eq(get_order_response['consumer']['email'])
    end
  end

end
