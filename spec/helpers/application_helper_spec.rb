require 'spec_helper'

describe ApplicationHelper, :type => :helper do
  describe '#get_hreflang_link' do
    before(:each) { allow(helper).to receive(:request).and_return(request_double) }

    context 'given the request fullpath with /au' do
      let(:request_double) { double('Request', fullpath: '/au/something') }

      it 'returns the fullpath without the /au' do
        result = helper.get_hreflang_link
        expect(result).to eq('/something')
      end
    end

    context 'given the request fullpath with /us' do
      let(:request_double) { double('Request', fullpath: '/us/something') }

      it 'returns the fullpath without the /us' do
        result = helper.get_hreflang_link
        expect(result).to eq('/something')
      end
    end

    context 'given the request fullpath without the locale prefix' do
      let(:request_double) { double('Request', fullpath: '/something') }

      it 'returns the same fullpath' do
        result = helper.get_hreflang_link
        expect(result).to eq('/something')
      end
    end
  end
end
