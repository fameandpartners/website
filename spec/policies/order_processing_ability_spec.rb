require 'spec_helper'
require 'cancan/matchers'

describe OrderProcessingAbility do

  subject(:ability) { OrderProcessingAbility.new(user) }
  let(:user)        { nil }

  context 'user without order processing role' do
    it{ should_not be_able_to(:admin, Spree::Order.new) }
    it{ should_not be_able_to(:admin, Spree::Shipment.new) }
    it{ should_not be_able_to(:admin, Spree::LineItem.new) }
  end

  context 'user with order processing role' do
    let(:user) { double(Spree::User) }

    before do
      allow(user).to receive(:has_spree_role?).with('order_processing').and_return(true)
    end
    it{ should be_able_to(:admin, Spree::Order.new) }
    it{ should be_able_to(:edit, Spree::Order.new) }
    it{ should be_able_to(:destroy, Spree::Order.new) }

    it{ should be_able_to(:admin, Spree::Shipment.new) }
    it{ should be_able_to(:edit, Spree::Shipment.new) }
    it{ should be_able_to(:destroy, Spree::Shipment.new) }

    it{ should be_able_to(:admin, Spree::LineItem.new) }
    it{ should be_able_to(:edit, Spree::LineItem.new) }
    it{ should_not be_able_to(:destroy, Spree::LineItem.new) }
  end

end
