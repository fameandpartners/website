require 'spec_helper'

describe Afterpay::Presenters::Payment do
  describe '#get_token' do
    let(:payment_method) { double(:payment_method) }
    let(:response) { { 'token' => 'payment_token' } }

    let(:spree_order) do
      double(:order, total: 10,
                     currency: 'USD',
                     phone: '123456',
                     firstname: 'John',
                     lastname: 'Doe',
                     email: 'jdoe@mail.com',
                     number: 731,
                     bill_address: address,
                     ship_address: address
                     )
    end

    let(:order) { Afterpay::Presenters::Order.new(spree_order: spree_order) }

    let(:address) do
      double(:address, phone: '123456',
                       firstname: 'John',
                       lastname: 'Doe',
                       name: 'John Doe',
                       address1: 'address1',
                       address2: 'address2',
                       city: 'Houston',
                       state: double(:state, abbr: 'TX'),
                       zipcode: '12345',
                       country: double(:country, iso: 'US'),
            )
    end

    let(:create_order_params) do
      {totalAmount: {amount: 10, currency: "USD"},
       consumer: 
       {phoneNumber: "123456",
        givenNames: "John",
        surname: "Doe",
        email: "jdoe@mail.com"},
        billing: 
        {name: "John Doe",
         line1: "address1",
         line2: "address2",
         suburb: "Houston",
         state: "TX",
         postcode: "12345",
         countryCode: "US",
         phoneNumber: "123456"},
       shipping:
        {name: "John Doe",
         line1: "address1",
         line2: "address2",
         suburb: "Houston",
         state: "TX",
         postcode: "12345",
         countryCode: "US",
         phoneNumber: "123456"},
         merchant:
         {redirectConfirmUrl: "confirmation_url",
          redirectCancelUrl: "checkout_url"},
          merchantReference: 731}
    end

    subject { described_class.new(spree_order: nil, spree_payment_method: nil, rails_request: nil) }

    it "creates order and gets token using payment_method" do
      allow(subject).to receive(:payment_method).and_return(payment_method)
      allow(subject).to receive(:order).and_return(order)

      expect(subject).to receive(:confirmation_url).and_return('confirmation_url')
      expect(subject).to receive(:checkout_url).and_return('checkout_url')

      expect(payment_method).to receive(:create_order).
        with(create_order_params).and_return(response)

      expect(subject.get_token).to eq('payment_token')
    end
  end
end
