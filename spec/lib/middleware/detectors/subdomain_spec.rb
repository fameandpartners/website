require 'spec_helper'

module Middleware
  module SiteVersion
    module Detectors
      RSpec.describe Subdomain do
        describe '#detect_site_version' do
          matcher :be_detected_as do |sv_code|
            match do |host|
              request_double = double(Rack::Request, host: host)
              result         = described_class.new.detect_site_version(request_double)
              result == sv_code
            end
          end

          context 'request has US subdomain' do
            it { expect('us.lvh.me').to be_detected_as('us') }
          end

          context 'request has AU subdomain' do
            it { expect('au.lvh.me').to be_detected_as('au') }
          end

          context 'request has an invalid subdomain' do
            it { expect('br.lvh.me').to be_detected_as('us') }
          end
        end
      end
    end
  end
end

