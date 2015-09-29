require 'spec_helper'

describe PinPaymentService, type: :service, vcr: { record: :new_episodes } do

  let(:opts) {
    {
        email:       'blah@vtha.com',
        amount:      1000, #CENTS
        currency:    'USD',
        description: 'Order #R851637568-[RANDOM]',
        ip_address:  '10.10.10.10', # OPTIONAL
        card:        {
            number:          card_number,
            expiry_month:    1,
            expiry_year:     2020,
            # cvc:              123, #OPTIONAL FOR MASTERPASS
            name:            'Blah Vtha',
            address_line1:   'Address',
            address_city:    'City',
            # address_postcode: '123456', #OPTIONAL
            # address_state:    'NSW', #OPTIONAL
            address_country: 'Australia'
        }
    }
  }

  let(:pin_api_key) { 'LElcjB_z4BItXJQPYlw43g' }
  let(:service)     { PinPaymentService.new(pin_api_key, opts) }
  let(:card_number) { '5520000000000000'}

  before do
    service.create_charge
  end

  context 'invalid details' do
    let(:opts) {{}}

    it 'does not create a charge' do
      expect(service.charge).to be_blank
    end
    it 'captures an error' do
      expect(service).to have_error
      expect(service.error).to be_present
    end
  end

  context 'declined' do
    let(:card_number) { '5560000000000001'}

    it 'does not create a charge' do
      expect(service.charge).to be_blank
    end
    it 'captures an error' do
      expect(service).to have_error
      expect(service.error).to be_present
    end
  end

  context 'insufficient Funds' do
    let(:card_number) { '5510000000000002'}
    
    it 'does not create a charge' do
      expect(service.charge).to be_blank
    end
    it 'captures an error' do
      expect(service).to have_error
      expect(service.error).to be_present
    end
  end


  context 'valid' do

    it 'creates a charge' do
      expect(service.charge).to be_present
      expect(service.charge.token).to be_present
    end
    it 'captures an error' do
      expect(service).to_not have_error
      expect(service.error).to_not be_present
    end
  end


end
