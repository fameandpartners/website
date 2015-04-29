require 'spec_helper'

describe ApplicationController, :type => :controller do
  describe '#url_with_correct_site_version' do
    before(:each) do
      allow(controller).to receive(:current_site_version).and_return(current_site_version_double)
    end

    context 'current site code is the default' do
      let(:current_site_version_double) { double('Current Site Version', code: 'us', default?: true) }

      before(:each) { controller.request.path_info = '/my-awesome-request' }

      it 'removes any site version code from the beginning of the URL' do
        result = controller.url_with_correct_site_version
        expect(result).to eq('http://test.host/my-awesome-request')
      end
    end

    describe 'current site code is anything else' do
      let(:current_site_version_double) { double('Current Site Version', code: 'au', default?: false) }

      context 'request is made with a specific code on its URL' do
        before(:each) { controller.request.path_info = '/us/my-awesome-request' }

        it 'returns the URL with the current site code' do
          result = controller.url_with_correct_site_version
          expect(result).to eq('http://test.host/au/my-awesome-request')
        end
      end

      context 'request is made to the default country' do
        before(:each) { controller.request.path_info = '/my-awesome-request' }

        it 'adds the site code to the beginning of the URL' do
          result = controller.url_with_correct_site_version
          expect(result).to eq('http://test.host/au/my-awesome-request')
        end
      end
    end
  end
end
