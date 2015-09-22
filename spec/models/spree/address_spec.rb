require 'spec_helper'

describe Spree::Address, type: :model do
  subject(:order)         { Spree::Order.new }
  before do
    @user = build(:spree_user)
    @user.save
  end

  context "#checkout" do
    context "no previous order" do
      before do
        order.user_id = @user.id
        @address = Spree::Address.new
        @address.set_last(@user, true, order)
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
      before do
        @address1 = build(:address)
        @address1.save
        @order = build(:spree_order)
        @order.user_id = @user.id
        @order.bill_address_id = @address1.id
        @order.state = 'complete'
        @order.save
        @order2 = build(:spree_order)
        @order2.user_id = @user.id
        @address2 = Spree::Address.new
        @address2.set_last(@user, true, @order2)
      end

      it "sets address1 the same as previous orders address1" do
        expect(@address2.address1).to eq(@address1.address1)
      end

      it "sets city the same as previous orders city" do
        expect(@address2.city).to eq(@address1.city)
      end

      it "sets zipcode the same as previous orders zipcode" do
        expect(@address2.zipcode).to eq(@address1.zipcode)
      end

      it "sets phone the same as previous orders phone" do
        expect(@address2.phone).to eq(@address1.phone)
      end

      it "sets state_id the same as previous orders state_id" do
        expect(@address2.state_id).to eq(@address1.state_id)
      end

      it "sets country_id the same as previous orders country_id" do
        expect(@address2.country_id).to eq(@address1.country_id)
      end
    end

    context "more than one previous order" do
      before do
        @address1 = build(:address)
        @address1.save
        @address2 = build(:address)
        @address2.save
        @order1 = build(:spree_order)
        @order1.user_id = @user.id
        @order1.bill_address_id = @address1.id
        @order1.state = 'complete'
        @order1.save
        @order2 = build(:spree_order)
        @order2.user_id = @user.id
        @order2.bill_address_id = @address2.id
        @order2.state = 'complete'
        @order2.save
        @order3 = build(:spree_order)
        @order3.user_id = @user.id
        @address3 = Spree::Address.new
        @address3.set_last(@user, true, @order3)
      end

      it "sets address1 the same as last orders address1" do
        expect(@address3.address1).to eq(@address2.address1)
      end

      it "sets city the same as last orders city" do
        expect(@address3.city).to eq(@address2.city)
      end

      it "sets zipcode the same as last orders zipcode" do
        expect(@address3.zipcode).to eq(@address2.zipcode)
      end

      it "sets phone the same as last orders phone" do
        expect(@address3.phone).to eq(@address2.phone)
      end

      it "sets state_id the same as last orders state_id" do
        expect(@address3.state_id).to eq(@address2.state_id)
      end

      it "sets country_id the same as last orders country_id" do
        expect(@address3.country_id).to eq(@address2.country_id)
      end
    end

  end
end
