require 'spec_helper'

describe WeddingAtelier::AccountsController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:previous_password) { 'spree123' }
  let(:new_password) { '123spree123' }
  let(:user) { create(:spree_user,
                      first_name: 'foo',
                      last_name: 'bar',
                      password: previous_password,
                      password_confirmation: previous_password) }
  before do
    custom_sign_in user
  end

  describe '#update' do
    context 'When updating account details' do
      context 'and the information is correct' do
        it 'updates basic information' do
          payload = {
            first_name: 'homer',
            last_name: 'simpson',
            email: 'homer@simpsons.com',
            dob: 10.years.ago
          }
          put :update, {id: user.id, account: payload}
          user.reload
          expect(user.first_name).to eq('homer')
        end
      end
      context 'and the information is wrong' do
        it 'returns errors' do
          payload = {
            first_name: 'homer',
            last_name: 'simpson',
            email: ''
          }
          put :update, {id: user.id, account: payload}
          parsed = ActiveSupport::JSON.decode(response.body)
          expect(parsed['errors']).not_to be_empty
        end
      end
    end
  end
  describe '#update_password' do
    context 'When updating password' do
      context 'and both passwords match and previous one is correct' do
        it 'updates password' do
          payload = {
            password: new_password,
            password_confirmation: new_password,
            current_password: previous_password
          }
          put :update, {id: user.id, account: payload}
          user.reload
          expect(user.valid_password?(new_password)).to be_truthy
        end
      end
      context 'when previous password is invalid' do
        it 'returns an error' do
          payload = {
            password: 'invalid',
            password_confirmation: new_password,
            current_password: previous_password
          }
          put :update, {id: user.id, account: payload}
          user.reload
          expect(user.valid_password?(previous_password)).to be_truthy
        end
      end
      context 'when previous password is not present' do
        it 'returns an error' do
          payload = {
            password_confirmation: new_password,
            current_password: previous_password
          }
          put :update, {id: user.id, account: payload}
          expect(response.code).to eq('422')
        end
      end
    end
  end
end
