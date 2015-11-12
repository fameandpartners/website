require 'spec_helper'

describe FindCountryFromIP, type: :service do
  let(:service) { described_class.new(ip) }

  describe '#country_code' do
    describe 'ipv4' do
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
    end

    describe 'ipv6' do
      context 'UK/GB' do
        let(:ip) { '0:0:0:0:0:ffff:d91b:faa0' }
        it { expect(service.country_code).to eq 'GB' }
      end

      context 'US' do
        let(:ip) { '2604:2000:f8ec:2400:d411:8c42:e0d4:ae60' }
        it { expect(service.country_code).to eq 'US' }
      end

      context 'AU' do
        let(:ip) { '0:0:0:0:0:ffff:36fc:708c' }
        it { expect(service.country_code).to eq 'AU' }
      end
    end

    describe 'invalid' do
      context 'bad ipv4' do
        let(:ip) { '666.666.666.666' }
        it { expect(service.country_code).to eq nil }
      end

      context 'bad ipv6' do
        let(:ip) { '1234.1234.1234.1234.1234.1234.1234.1234' }
        it { expect(service.country_code).to eq nil }
      end

      context 'worse' do
        let(:ip) { 'blah vtha' }
        it { expect(service.country_code).to eq nil }
      end

      context 'nil' do
        let(:ip) { nil }
        it { expect(service.country_code).to eq nil }
      end
    end
  end
end
