require 'spec_helper'

describe UserCountryFromIP do

  let(:country) { double('Country', :country_code2 => 'uk')}
  let(:service) { UserCountryFromIP.new(ip) }

  describe '#country_code' do

    context 'UK/GB' do
      let(:ip) { '217.27.250.160' }
      it { expect(service.country_code).to eq 'GB' }
    end

    context 'US' do
      let(:ip) { '74.86.15.72' }
      it { expect(service.country_code).to eq 'US' }
    end

    context 'AU' do
      let(:ip) { '54.252.112.140' }
      it { expect(service.country_code).to eq 'AU' }
    end

    context 'bad' do
      let(:ip) { '666.666.666.666' }
      it { expect(service.country_code).to eq '--' }
    end

    context 'nil' do
      let(:ip) { nil }
      it { expect(service.country_code).to eq nil }
    end
  end
end
