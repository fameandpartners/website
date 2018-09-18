require 'spec_helper'

describe Spree::UserMailer do
  context "#reset_password_instructions" do
    let(:user) { build(:spree_user) }
    let(:expected_attributes) { { password_reset_link: '/account/forgot-password/token/' } }

    it "sends data to customer io correctly" do
      expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(user, 'account_password_reset', expected_attributes)
      described_class.reset_password_instructions(user)
    end
  end
end
