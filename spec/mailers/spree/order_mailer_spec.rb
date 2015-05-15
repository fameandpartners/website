require 'spec_helper'

describe Spree::OrderMailer do
  context "#confirm_email" do
    let(:order)   { build(:spree_order) }
    let(:mail) { Spree::OrderMailer.confirm_email(order) }

    it "render content without error" do
      expect(mail.body.encoded).not_to be_empty
    end
  end
end
