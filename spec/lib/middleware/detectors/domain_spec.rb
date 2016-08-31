require 'spec_helper'

module Middleware
  module SiteVersion
    module Detectors
      RSpec.describe Domain do
        let(:detector) { described_class.new }

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

        describe '#default_url_options' do
          let(:au_site_version) { build_stubbed(:site_version, :au, :default) }
          let(:br_site_version) { build_stubbed(:site_version, :us) }

          it 'returns a hash with a nil site_version' do
            result = detector.default_url_options(au_site_version)
            expect(result).to eq({ site_version: nil })

            result = detector.default_url_options(br_site_version)
            expect(result).to eq({ site_version: nil })
          end
        end

        describe '#site_version_url' do
          let(:url) { 'http://example.com/something?in-the=way' }
          let(:br_site_version) { build_stubbed(:site_version, domain: 'example.com.br') }

          context 'given a URL and a site version' do
            it 'replaces the URL domain with the site version\'s' do
              result = detector.site_version_url(url, br_site_version)
              expect(result).to eq('http://example.com.br/something?in-the=way')
            end
          end

          context 'given a bad URL and a site version' do
            let(:url) { 'http://www.example.com/something?a+|+b&c=d' }

            it 'replaces the URL domain with the site version\'s' do
              result = detector.site_version_url(url, br_site_version)
              expect(result).to eq('http://example.com.br/something?a+|+b&c=d')
            end
          end
        end
      end
    end
  end
end

