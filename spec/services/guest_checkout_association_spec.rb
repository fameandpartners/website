require 'spec_helper'
describe GuestCheckoutAssociation, type: :service do
  subject(:order)     { Spree::Order.new }

  describe 'associate user when guest checkout based on email, first name and last name' do
    context 'guest checkout' do
      let(:match_user) { create(:spree_user, email: 'something@music.com', first_name: 'Something', last_name: 'Music') }
      let(:billing_address) { create(:address, firstname: match_user.first_name, lastname: match_user.last_name, email: match_user.email)}
      it 'should associate user' do
        order.billing_address = billing_address
        result = GuestCheckoutAssociation.associate_user_for_guest_checkout(spree_order: order, spree_current_user: nil)
        expect(result).to be true
        expect(order.user).to eq(match_user)
      end
      it 'should not associate user with correct email and incorrect first/last name' do
        result = GuestCheckoutAssociation.associate_user_for_guest_checkout(spree_order: order, spree_current_user: nil)
        expect(result).to be false
        expect(order.user).to be_nil
      end
    end
  end
end
