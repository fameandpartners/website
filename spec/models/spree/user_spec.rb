require 'spec_helper'

describe Spree::User, type: :model do
  describe "#subscriptions" do
    context "#create" do
      it "runs for new record" do
        user = build(:spree_user)
        user.newsletter = true

        expect(user).to receive(:create_marketing_subscriber)
        user.run_callbacks(:create)
      end

      it "don't run anything if we have no permission" do
        user = build(:spree_user)
        user.newsletter = false

        expect(user).not_to receive(:create_marketing_subscriber)
        user.run_callbacks(:create)
      end
    end

    context "#update" do
      it "on record update" do
        user = build(:spree_user)
        user.newsletter = true

        expect(user).to receive(:update_marketing_subsriber)
        user.run_callbacks(:update)
      end

      it "don't run anything if we have no permission" do
        user = build(:spree_user)
        user.newsletter = false

        expect(user).not_to receive(:update_marketing_subsriber)
        user.run_callbacks(:update)
      end
    end
  end
end
