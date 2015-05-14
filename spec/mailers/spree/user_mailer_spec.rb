require 'spec_helper'

describe Spree::UserMailer do
  context "#reset_password_instructions" do
    let(:user) { build(:spree_user) }
    let(:mail) { Spree::UserMailer.reset_password_instructions(user) }

    it "render content without error" do
      expect(mail.body.encoded).not_to be_empty
    end
  end
end
