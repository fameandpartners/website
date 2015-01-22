require 'spec_helper'

describe PaymentRequest do 

  let(:user)      { stub_model(Spree::User) }
  let(:state)     { 'cart' }
	let(:order)     { stub_model(Spree::Order, :state => state, :user => user) } 
  let(:message)   { 'And if you gaze long enough into an abyss, the abyss will gaze back into you.' } 
  let(:email)     { 'blah@vtha.com' }
  let(:full_name) { 'blah vtha' }
  
  subject(:payment_request) { PaymentRequest.new(:message => message, :recipient_email => email, :recipient_full_name => full_name ) }

  before do
    allow(order).to receive(:reload).and_return(order)

    allow(payment_request).to receive(:order).and_return(order)
  end

  describe 'validation' do

    it { should_not allow_mass_assignment_of :order }
    
    it { is_expected.to be_valid }
    
    it { should_not allow_value('', 'blah', 'blah@', 'blah@vtha').for(:recipient_email) }
    
    it { should validate_presence_of :recipient_email }

    context 'with bad order state' do
      let(:state) { 'Kwisatz/Haderach' }

      it 'is invalid' do
        expect(payment_request).to be_invalid
        expect(payment_request.errors).to include(:order) 
      end    
    end

    context 'with no data' do
      subject(:payment_request) { PaymentRequest.new }
      it { is_expected.to be_invalid }
    end
  end
end
