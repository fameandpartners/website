require 'spec_helper'

describe Spree::OrderMailer do
  context '#confirm_email' do
    let(:address)  { Spree::Address.new(:phone => '12345') }
    let(:order)   { build(:spree_order, :billing_address => address) }
    let(:mail) { Spree::OrderMailer.team_confirm_email(order) }

    it 'render content without error' do
      expect(mail.body.encoded).not_to be_empty
    end

    it 'renders with promotion info' do
      allow(order).to receive_message_chain(:adjustments, :eligible).and_return([])
      allow(order).to receive_message_chain(:adjustments, :where, :collect).and_return(['[blah] vtha'])
      expect(mail.body.encoded).to include 'blah'
    end
  end
end
