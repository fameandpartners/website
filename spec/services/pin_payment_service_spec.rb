require 'spec_helper'

describe PinPaymentService do

  let(:opts)        {{}}
  let(:pin_api_key) { "BLAH986498VTHA" }
  let(:service)     { PinPaymentService.new(pin_api_key, opts) }
  let(:error)       { PinPayment::Error::InvalidResource.new("ERROR") }

  context 'with payment error' do

    before do
      allow(PinPayment::Charge).to receive(:create).with(opts).and_raise(error)
      expect(NewRelic::Agent).to receive(:notice_error).with(error)
      expect(NewRelic::Agent).to receive(:notify)
      service.create_charge
    end

    it 'does not create a charge' do    
      expect(service.charge).to be_blank
    end

    it 'captures an error' do
      expect(service).to have_error
      expect(service.error).to be_present
      expect(service.error).to eq "ERROR"
    end
  end

end
