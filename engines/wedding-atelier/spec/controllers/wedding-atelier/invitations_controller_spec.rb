require 'spec_helper'

describe WeddingAtelier::InvitationsController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:event) { create(:wedding_atelier_event) }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar') }

  before do
    allow(controller).to receive(:wedding_atelier).and_return(WeddingAtelier::Engine.routes.url_helpers)
  end

  describe '#create' do
    before do
      custom_sign_in user
      allow(controller).to receive(:current_spree_user).and_return(user)
    end

    context 'When sending new invitations' do
      let(:params) do
        {
          event_id: event.slug,
          email_addresses: ['yo@example.com', 'yoyo@example.com']
        }
      end
      let(:customerio) { double(Marketing::CustomerIOEventTracker) }
      it 'saves the record and sends email' do
        allow(Marketing::CustomerIOEventTracker).to receive(:new).and_return(customerio)
        expect(customerio).to receive(:anonymous_track).twice
        expect do
          xhr :post, :create, params
        end.to change { WeddingAtelier::Invitation.count }.by(2)
      end
    end
  end

  describe '#accept' do
    context 'when accepting an invitation' do
      let(:invited) { create(:spree_user, first_name: 'invite', last_name: 'me')}
      let(:invitation) { event.invitations.create(inviter_id: user.id, user_email: invited.email) }
      it 'marks the invitation as accepted' do
        expect do
          get :accept, event_id: event.id, invitation_id: invitation.id
        end.to change { invitation.reload.state }.to('accepted')
      end
    end
  end
end
