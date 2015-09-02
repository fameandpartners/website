require 'spec_helper'

describe Admin::ChangeOrderOwner do
  context "#process" do
    let(:site_version) { build(:site_version) }
    let(:order)        { user.orders.build }
    let(:user)         { create(:spree_user) }

    it "do nothing if new user empty" do
      service = described_class.new(site_version: site_version, order: double('order', user: nil), new_owner_id: nil)
      expect(service.process!).to be false
    end

    it "do nothing if new user equal to old" do
      service = described_class.new(site_version: site_version, order: order, new_owner_id: user.id)
      expect(service.process!).to be false
    end

    it "changes user" do
      new_owner = create(:spree_user)
      service = described_class.new(site_version: site_version, order: order, new_owner_id: new_owner.id)

      expect(service).to receive(:notify_customer_io).and_return(true)
      expect(service.process!).to be true
    end

    it "copies cached order owner attributes" do
      new_owner = create(:spree_user)
      service = described_class.new(site_version: site_version, order: order, new_owner_id: new_owner.id)
      expect(service).to receive(:notify_customer_io).and_return(true)

      expect(service.process!).to be true

      expect(order.user_first_name).to eq(new_owner.first_name)
      expect(order.user_last_name).to eq(new_owner.last_name)
      expect(order.email).to eq(new_owner.email)
    end

    it "notify customerio" do
      new_owner = create(:spree_user)
      service = described_class.new(site_version: site_version, order: order, new_owner_id: new_owner.id)
      service.process

      tracker = double(:tracker)
      expect(tracker).to receive(:track).with(new_owner, 'order:new_owner', {
        order_number: order.number,
        original_customer_email: user.email,
        updated_customer_email: new_owner.email
      })
      expect(service).to receive(:tracker).and_return(tracker)
      expect(service.process!).to be true
    end
  end
end
