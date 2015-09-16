require 'spec_helper'

describe Marketing::Gtm::Presenter::Device, type: :presenter do
  let(:user_agent) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36' }

  subject(:presenter) { described_class.new(user_agent: user_agent) }

  it_behaves_like 'a Marketing::Gtm::Presenter::Base'

  describe '#body' do
    context 'given an user agent' do
      it 'returns hash with device info' do
        expect(subject.body).to eq({
                                       browser: 'Chrome',
                                       os:      'Mac 10.10.1',
                                       type:    'desktop'
                                   })
      end
    end
  end
end
