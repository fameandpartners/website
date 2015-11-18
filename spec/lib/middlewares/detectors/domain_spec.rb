require 'spec_helper'

module Middleware
  module SiteVersion
    module Detectors
      RSpec.describe Domain do
        describe '#detect_site_version' do
          subject { described_class.new }

          shared_examples 'return code given domain' do |sv_code, host|
            let(:request) { double(Rack::Request, host: host) }

            it do
              result = subject.detect_site_version(request)
              expect(result).to eq(sv_code)
            end
          end

          context 'request has US domain' do
            it_will 'return code given domain', 'us', 'fameandpartners.com'
            it_will 'return code given domain', 'us', 'www.fameandpartners.com'
          end

          context 'request has AU domain' do
            it_will 'return code given domain', 'au', 'fameandpartners.com.au'
            it_will 'return code given domain', 'au', 'www.fameandpartners.com.au'
          end

          context 'request has invalid domain' do
            describe 'returns default code' do
              it_will 'return code given domain', 'us', 'fameandpartners.com.br'
            end
          end
        end
      end
    end
  end
end

