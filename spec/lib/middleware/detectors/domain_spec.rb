require 'spec_helper'

module Middleware
  module SiteVersion
    module Detectors
      RSpec.describe Domain do
        describe '#detect_site_version' do
          matcher :be_detected_as do |sv_code|
            match do |host|
              request_double = double(Rack::Request, host: host)
              result         = described_class.new.detect_site_version(request_double)
              result == sv_code
            end
          end

          context 'request has US domain' do
            it { expect('www.fameandpartners.com').to be_detected_as('us') }
            it { expect('fameandpartners.com').to be_detected_as('us') }
          end

          context 'request has AU domain' do
            it { expect('www.fameandpartners.com.au').to be_detected_as('au') }
            it { expect('fameandpartners.com.au').to be_detected_as('au') }
          end

          context 'request has invalid domain' do
            it { expect('fameandpartners.com.br').to be_detected_as('us') }
          end
        end
      end
    end
  end
end

