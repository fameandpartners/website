require 'rails_helper'

RSpec.describe Bronto::Client do
  describe '#login' do
    let(:soap) { double(:soap) }
    let(:client) { subject.send(:client) }

    it 'requests login entry point' do
      expect(soap).to receive(:body=).with({api_token: 'token'})
      expect(subject).to receive(:soap).and_return(soap)
      expect(client).to receive(:request).and_yield

      subject.send(:login)
    end
  end

  describe '#session_id' do
    let(:response) { double(:response, body: body) }

    before { is_expected.to receive(:login).exactly(1).times.and_return(response) }

    describe 'login succeed' do
      let(:body) { { login_response: { return: 'some_session_id' } } }

      it 'fetches session_id from login response' do
        expect(subject.send(:session_id)).to eq('some_session_id')
        expect(subject.send(:session_id)).to eq('some_session_id')
      end
    end

    describe 'login failed' do
      let(:body) { { } }

      it 'is nil' do
        expect(subject.send(:session_id)).to be_nil
      end
    end
  end

  describe '#logout' do
    it 'requests logout and clears session_id' do
      subject.instance_variable_set('@session_id', 'some_session_id')
      expect(subject.send(:session_id)).to eq('some_session_id')

      is_expected.to receive(:request).with(:logout)
      subject.send(:logout)

      expect(subject.instance_variable_get('@session_id')).to be_nil
    end
  end

  describe '#request' do
    let(:soap) { OpenStruct.new(body: nil, header: nil) }
    let(:client) { subject.send(:client) }

    before { allow(subject).to receive(:soap).and_return(soap) }
    before { allow(subject).to receive(:soap_header).and_return(:some_header) }

    it 'delegates request to client' do
      expect(client).to receive(:request).with(:some_action)

      subject.send(:request, :some_action)
    end

    it 'sets soap header and body' do
      expect(client).to receive(:request).with(:some_action).and_yield

      subject.send(:request, :some_action, :some_body)

      expect(soap.header).to eq(:some_header)
      expect(soap.body).to eq(:some_body)
    end

    it 'yields soap' do
      expect(client).to receive(:request).with(:some_action).and_yield

      subject.send(:request, :some_action, :some_body) do |soap_object|
        soap_object.body = 'yielded_value'
      end

      expect(soap.header).to eq(:some_header)
      expect(soap.body).to eq("yielded_value")
    end
  end
end
