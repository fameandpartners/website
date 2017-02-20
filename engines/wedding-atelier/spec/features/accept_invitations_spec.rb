require 'spec_helper'

describe 'invitations', type: :feature do
  describe 'accept invitations' do
    let(:event){ create(:wedding_atelier_event) }
    let(:user){ create(:spree_user) }
    let(:invited_user){ create(:spree_user, wedding_atelier_signup_step: 'completed') }
    let(:customerio) { double(Marketing::CustomerIOEventTracker) }
    let(:invitation){ event.invitations.create(inviter_id: user.id, user_email: invited_user.email)}

    before(:each) do
      enable_wedding_atelier_feature_flag
      create(:option_type, name: 'dress-size')
      user.events << event
    end


    context 'when already accepted' do
      before { invitation.update_attribute(:state, 'accepted')}
      it 'indicates the invitation has been accepted' do
        visit "wedding-atelier/events/#{event.id}/invitations/#{invitation.id}/accept"
        expect(page.current_path).to eq "/wedding-atelier/signup"
        expect(react_flash_errors[0]).to eq 'This is invitation has already been accepted.'
      end
    end

    context 'when user exists and is signed in' do
      it 'accepts the invitation and redirects to event' do
        visit '/wedding-atelier/sign_in'
        within('.email-signup') do
          fill_in 'spree_user_email', with: invited_user.email
          fill_in 'spree_user_password', with: invited_user.password
        end
        click_button 'Sign in'
        visit "wedding-atelier/events/#{event.id}/invitations/#{invitation.id}/accept"
        expect(invitation.reload.state).to eq 'accepted'
        expect(invited_user.reload.events.length).to eq 1
        expect(page.current_path).to eq "/wedding-atelier/events/#{event.id}/#{event.slug}"
      end
    end

    context 'when user exists but is not signed in' do
      it 'takes the user to login and accepts invitation' do
        visit "wedding-atelier/events/#{event.id}/invitations/#{invitation.id}/accept"
        url = URI.parse(page.current_url)
        expect(url.path).to eq '/wedding-atelier/sign_in'
        expect(url.query).to eq "invitation_id=#{invitation.id}"
        within('.email-signup') do
          fill_in 'spree_user_email', with: invited_user.email
          fill_in 'spree_user_password', with: invited_user.password
        end
        click_button 'Sign in'
        expect(invitation.reload.state).to eq 'accepted'
        expect(invited_user.reload.events.length).to eq 1
        expect(page.current_path).to eq "/wedding-atelier/events/#{event.id}/#{event.slug}"
      end
    end

    context 'when user doesnt exist' do
      before do
        allow_any_instance_of(Spree::User).to receive(:send_welcome_email)
        allow_any_instance_of(EmailCaptureWorker).to receive(:perform_async)
      end

      it 'takes the user to signup and accepts invitation' do
        invitation = event.invitations.create(inviter_id: user.id, user_email: 'new@user.com')
        visit "wedding-atelier/events/#{event.id}/invitations/#{invitation.id}/accept"
        url = URI.parse(page.current_url)
        expect(url.path).to eq '/wedding-atelier/signup'
        expect(url.query).to eq "invitation_id=#{invitation.id}"
        within('.new_spree_user') do
          fill_in 'spree_user_first_name', with: 'new'
          fill_in 'spree_user_last_name', with: 'user'
          fill_in 'spree_user_password', with: 'password'
        end
        click_button 'Next'
        expect(invitation.reload.state).to eq 'accepted'
        user = Spree::User.where(email: 'new@user.com').first
        expect(user.events.length).to eq 1
        expect(page.current_path).to eq "/wedding-atelier/signup/size"
      end
    end
  end
 end
