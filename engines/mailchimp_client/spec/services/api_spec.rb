require 'spec_helper'

module MailChimpClient
  RSpec.describe API, type: :service do
    let(:api) { described_class.new }
    let(:user) { build(:spree_user) }

    before do
      allow(user).to receive(:id).and_return(1)
      allow(user).to receive(:email).and_return('user1@gmail.com')
      allow(user).to receive(:first_name).and_return('first_name_1')
      allow(user).to receive(:last_name).and_return('last_name_1')
    end

    describe('#add_cusotmer', :vcr) do

      it('adds customer to MailChimp') do
        response = api.add_customer(user)
        expect(response['id']).to eql(user.id.to_s)
        expect(response['email_address']).to eql(user.email)
        expect(response['first_name']).to eql(user.first_name)
        expect(response['last_name']).to eql(user.last_name)
      end
    end

    describe('#add_order', :vcr) do
      let(:order) { create(:complete_order_with_items) }

      before do
        allow(order).to receive(:user).and_return(user)
        allow(order.line_items.first).to receive(:id).and_return(1)
        allow(order).to receive(:number).and_return('R047672844')
      end

      it('adds order to MailChimp') do
        response = api.add_order(order)
        expect(response['id']).to eql(order.number)
        expect(response['customer']['id']).to eql(order.user.id.to_s)
        expect(response['customer']['email_address']).to eql(order.user.email)
        expect(response['customer']['first_name']).to eql(order.user.first_name)
        expect(response['customer']['last_name']).to eql(order.user.last_name)
      end
    end
  end
end
