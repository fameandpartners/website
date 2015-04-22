require 'spec_helper'
require 'cancan/matchers'

describe CustomerServiceAbility do

  subject(:ability) { CustomerServiceAbility.new(user) }
  let(:user)        { nil }

  context 'when user is not a custoemr service officer' do
    it{ should_not be_able_to(:admin, Spree::Order.new) }
    it{ should_not be_able_to(:edit, Spree::Order.new) }
    it{ should_not be_able_to(:destroy, Spree::Order.new) }

    it{ should_not be_able_to(:admin, Spree::Shipment.new) }
    it{ should_not be_able_to(:edit, Spree::Shipment.new) }
    it{ should_not be_able_to(:destroy, Spree::Shipment.new) }

    it{ should_not be_able_to(:admin, Spree::LineItem.new) }
    it{ should_not be_able_to(:edit, Spree::LineItem.new) }
    it{ should_not be_able_to(:destroy, Spree::LineItem.new) }
  end

  context 'when user is a customer service officer' do
    let(:user) { double(Spree::User) }

    before do
      allow(user).to receive(:has_spree_role?).with('customer_service').and_return(true)
    end

    it{ should be_able_to(:admin, Spree::Order.new) }
    it{ should be_able_to(:index, Spree::Order.new) }
    it{ should be_able_to(:show, Spree::Order.new) }
    it{ should_not be_able_to(:edit, Spree::Order.new) }
    it{ should_not be_able_to(:destroy, Spree::Order.new) }

    it{ should be_able_to(:admin, Spree::Shipment.new) }
    it{ should be_able_to(:index, Spree::Shipment.new) }
    it{ should be_able_to(:show, Spree::Shipment.new) }
    it{ should_not be_able_to(:edit, Spree::Shipment.new) }
    it{ should_not be_able_to(:destroy, Spree::Shipment.new) }
  end

end
