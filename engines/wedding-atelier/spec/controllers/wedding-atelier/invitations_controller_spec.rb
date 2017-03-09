require 'spec_helper'

describe WeddingAtelier::InvitationsController, type: :controller do
  before(:each) { enable_wedding_atelier_feature_flag }

  routes { WeddingAtelier::Engine.routes }
  let(:event) { create(:wedding_atelier_event) }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar') }

  before do
    allow(controller).to receive(:wedding_atelier).and_return(WeddingAtelier::Engine.routes.url_helpers)
  end

  describe '#create' do
    before do
      wedding_sign_in user
      allow(controller).to receive(:current_spree_user).and_return(user)
    end

    context 'When sending new invitations' do
      let(:params) do
        {
          event_id: event.id,
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
    context 'when user is logged in' do
      let(:invited_user) { create(:spree_user, first_name: 'invite', last_name: 'me', email: 'logged@user.com')}
      let(:invitation) { event.invitations.create(inviter_id: user.id, user_email: invited_user.email) }
      it 'accepts the invitation and redirects to event' do
        allow(controller).to receive(:spree_user_signed_in?).and_return true
        expect do
          get :accept, event_id: event.id, invitation_id: invitation.id
        end.to change{invitation.reload.state}.from('pending').to('accepted')
      end
    end

    context 'when user is not logged in but exists' do
      let!(:invited) { create(:spree_user, first_name: 'invite', last_name: 'me', email: 'invited@user.com')}
      let(:invitation) { event.invitations.create(inviter_id: user.id, user_email: 'INVited@uSer.com') }
      it 'finds the user no matter caps and redirects to login' do
        get :accept, event_id: event.id, invitation_id: invitation.id
        expect(response).to redirect_to("/wedding-atelier/sign_in?invitation_id=#{invitation.id}")
      end
    end

    context 'when user does not exist' do
      let(:invitation) { event.invitations.create(inviter_id: user.id, user_email: 'neW@uSer.com') }
      it 'finds the user no matter caps and redirects to login' do
        get :accept, event_id: event.id, invitation_id: invitation.id
        expect(response).to redirect_to("/wedding-atelier/signup?invitation_id=#{invitation.id}")
      end
    end
  end
end
