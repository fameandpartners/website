require 'spec_helper'

describe ApplicationController, :type => :controller do
  describe '#url_with_correct_site_version' do
    before(:each) do
      allow(controller).to receive_messages(
        current_site_version: current_site_version_double,
        request: request_double
      )
    end

    context 'current site code is the default' do
      let(:current_site_version_double) { double('Current Site Version', code: 'us', default?: true) }
      let(:request_double) { double('Request', fullpath: '/au/my-awesome-request') }

      it 'removes any site version code from the beginning of the URL' do
        result = controller.url_with_correct_site_version
        expect(result).to eq('/my-awesome-request')
      end
    end

    describe 'current site code is anything else' do
      let(:current_site_version_double) { double('Current Site Version', code: 'au', default?: false) }

      context 'request is made with a specific code on its URL' do
        let(:request_double) { double('Request', fullpath: '/us/my-awesome-request') }

        it 'returns the URL with the current site code' do
          result = controller.url_with_correct_site_version
          expect(result).to eq('/au/my-awesome-request')
        end
      end

      context 'request is made to the default country' do
        let(:request_double) { double('Request', fullpath: '/my-awesome-request', default?: false) }

        it 'adds the site code to the beginning of the URL' do
          result = controller.url_with_correct_site_version
          expect(result).to eq('/au/my-awesome-request')
        end
      end
    end
  end
end
