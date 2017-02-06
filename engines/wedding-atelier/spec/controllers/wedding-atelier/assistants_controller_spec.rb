require 'spec_helper'

describe WeddingAtelier::AssistantsController, type: :controller do
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar', wedding_atelier_signup_step: 'completed') }

  before do
    custom_sign_in user
    allow(controller).to receive(:current_spree_user).and_return(user)
    user.add_role('bridesmaid', event)
  end

  describe '#destroy' do
    let(:event){ create(:wedding_atelier_event) }
    context 'when the assistant is found' do
      before { event.assistants << user }
      it 'removes the assistant from the board' do
        params = { event_id: event.id, id: event.assistants.last.id }
        expect{delete :destroy, params}.to change{event.event_assistants.count}.by(-1)
      end
    end

    context 'when the assistant is not found' do
      it 'returns an error' do
        params = { event_id: event.id, id: 1231 }
        delete :destroy, params
        json_response = JSON.parse(response.body)
        expect(response.status).to eq 404
        expect(json_response["errors"]).to eq "Couldn't find board member"
      end
    end
  end
end
