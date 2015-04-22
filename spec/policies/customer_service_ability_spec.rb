require 'spec_helper'
require 'cancan/matchers'

describe Policies::CustomerServiceAbility do

  subject(:ability) { Policies::CustomerServiceAbility.new(user) }
  let(:user)    { nil }

  context 'user is not a custoemr service officer' do
    it{ should_not be_able_to(:admin, Spree::Order.new) }
    it{ should_not be_able_to(:admin, Spree::Shipment.new) }
    it{ should_not be_able_to(:admin, Spree::LineItem.new) }
  end

  context 'user is a customer service officer' do
    let(:user) { double(Spree::User) }

    before do
      allow(user).to receive(:has_spree_role?).with('Customer Service').and_return(true)
    end
    it{ should be_able_to(:admin, Spree::Order.new) }
    it{ should be_able_to(:admin, Spree::Shipment.new) }
    it{ should be_able_to(:admin, Spree::LineItem.new) }
  end

end
