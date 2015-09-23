require 'spec_helper'

describe Spree::Address, type: :model do
  subject(:order)         { Spree::Order.new }
  let!(:user) { create(:spree_user) }

  context "#checkout" do
    context "no previous order" do
      before do
        order.user_id = user.id
        @address = Spree::Address.new
        @address.set_last(user, true, order)
      end

      it "does not set address1" do
        expect(@address.address1).to be_nil
      end

      it "does not set city" do
        expect(@address.city).to be_nil
      end

      it "does not set zipcode" do
        expect(@address.zipcode).to be_nil
      end

      it "does not set phone" do
        expect(@address.phone).to be_nil
      end

      it "does not set state_id" do
        expect(@address.state_id).to be_nil
      end

      it "does not set country_id" do
        expect(@address.country_id).to be_nil
      end
    end

    context "one previous order" do
      let!(:address1) { create(:address, email: user.email) }
      let(:order) { create(:spree_order, state: 'complete',
                           bill_address: address1, user: user) }
      let(:order2) { create(:spree_order, user: user) }
      before do
        address1.save
        order.save
        order2.save
        @address2 = Spree::Address.new
        @address2.set_last(user, true, @order2)
      end

      it "sets address1 the same as previous orders address1" do
        expect(@address2.address1).to eq(address1.address1)
      end

      it "sets city the same as previous orders city" do
        expect(@address2.city).to eq(address1.city)
      end

      it "sets zipcode the same as previous orders zipcode" do
        expect(@address2.zipcode).to eq(address1.zipcode)
      end

      it "sets phone the same as previous orders phone" do
        expect(@address2.phone).to eq(address1.phone)
      end

      it "sets state_id the same as previous orders state_id" do
        expect(@address2.state_id).to eq(address1.state_id)
      end

      it "sets country_id the same as previous orders country_id" do
        expect(@address2.country_id).to eq(address1.country_id)
      end
    end

    context "more than one previous order" do
      let!(:address1) { create(:address, email: user.email) }
      let!(:address2) { create(:address, email: user.email) }
      let(:order1) { create(:spree_order, state: 'complete',
                           bill_address: address1, user: user) }
      let(:order2) { create(:spree_order, state: 'complete',
                            bill_address: address2, user: user) }
      let(:order3) { create(:spree_order, user: user) }
      before do
        address1.save
        address2.save
        order1.save
        order2.save
        order3.save
        @address3 = Spree::Address.new
        @address3.set_last(user, true, order3)
      end

      it "sets address1 the same as last orders address1" do
        expect(@address3.address1).to eq(address2.address1)
      end

      it "sets city the same as last orders city" do
        expect(@address3.city).to eq(address2.city)
      end

      it "sets zipcode the same as last orders zipcode" do
        expect(@address3.zipcode).to eq(address2.zipcode)
      end

      it "sets phone the same as last orders phone" do
        expect(@address3.phone).to eq(address2.phone)
      end

      it "sets state_id the same as last orders state_id" do
        expect(@address3.state_id).to eq(address2.state_id)
      end

      it "sets country_id the same as last orders country_id" do
        expect(@address3.country_id).to eq(address2.country_id)
      end
    end

  end
end
