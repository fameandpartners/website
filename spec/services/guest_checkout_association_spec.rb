require 'spec_helper'

describe GuestCheckoutAssociation, type: :service do
  let!(:order) { create(:spree_order) }
  let!(:user) { create(:spree_user, email: 'something@music.com', first_name: 'Something', last_name: 'Music') }

  describe 'associate user to a completed order' do
    context 'bill address email, first and last name matches an existing user' do
      let!(:bill_address) { create(:address, firstname: 'Something', lastname: 'Music', email: 'something@music.com') }

      before(:each) do
        order.bill_address = bill_address
        order.save
      end

      it 'associates user with order' do
        result = GuestCheckoutAssociation.associate_user_for_guest_checkout(spree_order: order, spree_current_user: nil)
        expect(result).to be true
        expect(order.reload.user).to eq(user)
      end
    end

    context 'bill address information does not match any user' do
      it 'should not associate user with correct email and incorrect first/last name' do
        result = GuestCheckoutAssociation.associate_user_for_guest_checkout(spree_order: order, spree_current_user: nil)
        expect(result).to be false
        expect(order.reload.user).to be_nil
      end
    end
  end
end
