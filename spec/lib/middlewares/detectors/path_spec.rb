require_relative '../../../../lib/middlewares/site_version/detectors/path'

module Middleware
  module SiteVersion
    module Detectors
      RSpec.describe Path do
        describe '#detect_site_version' do
          subject { described_class.new }

          shared_examples 'it will return code for path' do |sv_code, path|
            let(:request) { double(Rack::Request, path: path) }

            it do
              result = subject.detect_site_version(request)
              expect(result).to eq(sv_code)
            end
          end

          context 'given a rack request' do
            context 'with a path containing AU code' do
              it_behaves_like 'it will return code for path', 'au', '/au'
              it_behaves_like 'it will return code for path', 'au', '/au/'
              it_behaves_like 'it will return code for path', 'au', '/au/something'
              it_behaves_like 'it will return code for path', 'au', '/au/something/'
            end

            context 'with an empty path' do
              it_behaves_like 'it will return code for path', 'us', '/'
              it_behaves_like 'it will return code for path', 'us', '/something'
            end

            context 'with an invalid code' do
              it_behaves_like 'it will return code for path', 'us', '/br'
              it_behaves_like 'it will return code for path', 'us', '/br/'
              it_behaves_like 'it will return code for path', 'us', '/br/something'
            end
          end
        end
      end
    end
  end
end
