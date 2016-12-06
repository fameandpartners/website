require File.expand_path('../../../spec_helper.rb', __FILE__)

describe WeddingAtelier::TwilioController, type: :controller do
  let(:user) { double(Spree::User, full_name: 'Full Name')}
  before do
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:spree_current_user).and_return(user)
  end

  describe '#token' do
    context 'when requesting a token' do
      let(:token) { double(Twilio::Util::AccessToken, to_jwt: 'supersecrettokene')}
      it 'responds with a json structure' do
        allow(Twilio::Util::AccessToken).to receive(:new).and_return(token)
        expect(token).to receive(:add_grant)
        spree_post :token
        expect(response).to be_ok
        parsed = ActiveSupport::JSON.decode(response.body)
        expect(parsed).to be_present
      end
    end
  end
end
