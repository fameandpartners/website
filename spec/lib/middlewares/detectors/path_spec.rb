require_relative '../../../../lib/middlewares/site_version/detectors/path'

module Middleware
  module SiteVersion
    module Detectors
      RSpec.describe Path do
        describe '#detect_site_version' do
          subject { described_class.new }

          context 'given a rack request' do
            context 'with a path containing AU code' do
              shared_examples 'it will return the au code' do |path|
                let(:request)  { double(Rack::Request, path: path) }

                it do
                  result = subject.detect_site_version(request)
                  expect(result).to eq('au')
                end
              end

              it_behaves_like 'it will return the au code', '/au'
              it_behaves_like 'it will return the au code', '/au/'
              it_behaves_like 'it will return the au code', '/au/something'
              it_behaves_like 'it will return the au code', '/au/something/'
            end

            context 'with an empty path' do
              let(:request) { double(Rack::Request, path: '/something') }

              it 'returns the default code' do
                result = subject.detect_site_version(request)
                expect(result).to eq('us')
              end
            end
          end
        end
      end
    end
  end
end
