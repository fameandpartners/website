require 'spec_helper'

describe Spree::UserMailer do
  context "#reset_password_instructions" do
    let(:user) { build(:spree_user) }
    
    it "sends data to customer io correctly" do
      let(:expected_attributes) { { password_reset_link: '/account/forgot-password/token/' } }

      Features.active(:new_product)
      expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(user, 'account_password_reset', expected_attributes)
      described_class.reset_password_instructions(user)
    end

    it "render content without error" do
      Features.deactivate(:new_product)
      let(:mail) { Spree::UserMailer.reset_password_instructions(user) }
      expect(mail.body.encoded).not_to be_empty
    end
  end
end
