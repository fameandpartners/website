require 'spec_helper'

describe Spree::UserMailer do
  if Features.active?(:new_account)
    context "#reset_password_instructions" do
      let(:user) { build(:spree_user) }
      let(:expected_attributes) { { password_reset_link: '/account/forgot-password/token/' } }

      it "sends data to customer io correctly" do
        expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(user, 'account_password_reset', expected_attributes)
        described_class.reset_password_instructions(user)
      end
    end
  else
    context "#reset_password_instructions" do
      let(:user) { build(:spree_user) }
      let(:mail) { Spree::UserMailer.reset_password_instructions(user) }
  
      it "render content without error" do
        expect(mail.body.encoded).not_to be_empty
      end
    end
  end
end
