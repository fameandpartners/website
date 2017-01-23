require 'spec_helper'

describe WeddingAtelier::Invitation do
  let(:event){ create(:wedding_atelier_event) }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar') }

  describe '#accept' do
    let(:invitation) { create(:wedding_atelier_invitation, event_slug: event.slug, user_email: user.email) }
    it 'changes the invitation state and assigns role to user' do
      expect{invitation.accept}.to change{invitation.state}.from('pending').to('accepted')
      expect(user.role_in_event(event)).to eq 'bridesmaid'
    end
  end

  describe 'self.pending' do
    it 'returns only pending invites' do
      create(:wedding_atelier_invitation, event_slug: event.slug)
      create(:wedding_atelier_invitation, state: 'accepted', event_slug: event.slug)
      expect(WeddingAtelier::Invitation.pending.size).to eq 1
    end
  end
end
