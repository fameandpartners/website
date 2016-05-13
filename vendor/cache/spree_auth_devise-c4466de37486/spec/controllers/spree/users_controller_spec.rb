require 'spec_helper'

describe Spree::UsersController do
  let(:admin_user) { create(:user) }
  let(:user) { create(:user) }
  let(:role) { create(:role) }

  before do
    controller.stub(:spree_current_user => user)
  end

  context '#create' do
    it 'should create a new user' do
      spree_post :create, { :user => { :email => 'foobar@example.com', :password => 'foobar123', :password_confirmation => 'foobar123' } }
      assigns[:user].new_record?.should be_false
    end
  end

  context '#update' do
    context 'when updating own account' do
      it 'should perform update' do
        spree_put :update, { :user => { :email => 'mynew@email-address.com' } }
        assigns[:user].email.should == 'mynew@email-address.com'
        response.should redirect_to(spree.account_url(:only_path => true))
      end

      it 'should not update roles' do
        expect {spree_put :update, { :user => { :spree_role_ids => [role.id] } }}.to raise_exception(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end
end
