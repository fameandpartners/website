require 'spec_helper'

describe Spree::UserMailer do
  context "#reset_password_instructions - customerio" do
    before(:each) { Features.activate(:new_account) }

    let(:user) { create(:spree_user, email: 'loroteiro@silvestre.com') }
    let(:expected_attributes) { { password_reset_link: 'http://localhost/account/forgot-password/token/', email_to: 'loroteiro@silvestre.com'} }


    it "sends data to customer io correctly" do

      expect_any_instance_of(Marketing::CustomerIOEventTracker).to receive(:track).with(user, 'account_password_reset', expected_attributes)
      described_class.reset_password_instructions(user)
    end
  end

  context "#reset_password_instructions - mailer" do
    before(:each) { Features.deactivate(:new_account) }

    let(:user) { build(:spree_user) }
    let(:mail) { Spree::UserMailer.reset_password_instructions(user) }

    it "render content without error" do
      expect(mail.body.encoded).not_to be_empty
    end
  end
end
