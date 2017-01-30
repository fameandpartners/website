require 'spec_helper'

describe WeddingAtelier::TwilioController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  before do
    wedding_sign_in create(:spree_user, first_name: 'foo', last_name: 'bar')
  end

  describe '#token' do
    context 'when requesting a token' do
      let(:token) { double(Twilio::Util::AccessToken, to_jwt: 'supersecrettokene')}
      it 'responds with a json structure' do
        allow(Twilio::Util::AccessToken).to receive(:new).and_return(token)
        expect(token).to receive(:add_grant)
        post :token
        expect(response).to be_ok
        parsed = ActiveSupport::JSON.decode(response.body)
        expect(parsed).to be_present
      end
    end
  end
end
