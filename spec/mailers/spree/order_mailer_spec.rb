require 'spec_helper'

describe Spree::OrderMailer do
  context "#confirm_email" do
    let(:order)   { build(:spree_order) }
    let(:mail) { Spree::OrderMailer.confirm_email(order) }

    it "render content without error" do
      expect(mail.body.encoded).not_to be_empty
    end

    it "render order number" do
      number = 'some_unique_spree_order_number'
      expect(order).to receive(:number).at_least(:once).and_return(number)
      expect(mail.body.encoded).to match(number)
    end
  end
end
