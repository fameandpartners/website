require 'spec_helper'

module Middleware
  module SiteVersion
    module Detectors
      RSpec.describe Path do
        let(:detector) { described_class.new }

        describe '#detect_site_version' do
          matcher :be_detected_as do |sv_code|
            match do |path|
              request_double = double(Rack::Request, path: path)
              result         = described_class.new.detect_site_version(request_double)
              result == sv_code
            end
          end

          context 'given a rack request' do
            context 'with a path containing AU code' do
              it { expect('/au').to be_detected_as('au') }
              it { expect('/au/').to be_detected_as('au') }
              it { expect('/au/something').to be_detected_as('au') }
              it { expect('/au/something/').to be_detected_as('au') }
            end

            context 'with an empty path' do
              it { expect('/').to be_detected_as('us') }
              it { expect('/something').to be_detected_as('us') }
            end

            context 'with an invalid code' do
              it { expect('/br').to be_detected_as('us') }
              it { expect('/br/').to be_detected_as('us') }
              it { expect('/br/something').to be_detected_as('us') }
            end
          end
        end

        describe '#default_url_options' do
          context 'given a default site version' do
            let(:site_version) { build_stubbed(:site_version, :default) }

            it 'returns a hash with a nil site_version' do
              result = detector.default_url_options(site_version)
              expect(result).to eq({ site_version: nil })
            end
          end

          context 'given a site version' do
            let(:site_version) { build_stubbed(:site_version, :au) }

            it 'returns a hash with the site version code' do
              result = detector.default_url_options(site_version)
              expect(result).to eq({ site_version: 'au' })
            end
          end
        end

        describe '#site_version_url' do
          pending 'TODO: Currently, this is only calling LocalizeUrlService.localize_url. See its method TODO for more information'
        end
      end
    end
  end
end
