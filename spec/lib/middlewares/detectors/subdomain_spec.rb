require 'spec_helper'

module Middleware
  module SiteVersion
    module Detectors
      RSpec.describe Subdomain do
        describe '#detect_site_version' do
          subject { described_class.new }

          shared_examples 'return code given subdomain' do |sv_code, host|
            let(:request) { double(Rack::Request, host: host) }

            it do
              result = subject.detect_site_version(request)
              expect(result).to eq(sv_code)
            end
          end

          context 'request has US subdomain' do
            it_will 'return code given subdomain', 'us', 'us.lvh.me'
          end

          context 'request has AU subdomain' do
            it_will 'return code given subdomain', 'au', 'au.lvh.me'
          end

          context 'request has an invalid subdomain' do
            describe 'return default code' do
              it_will 'return code given subdomain', 'us', 'br.lvh.me'
            end
          end
        end
      end
    end
  end
end

