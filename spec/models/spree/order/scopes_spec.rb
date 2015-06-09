require 'spec_helper'

describe Spree::Order::Scopes, :type => :model do

  describe '.completed' do
    let!(:completed_order)    { create :complete_order }
    let!(:incomplete_order)   { create :spree_order }
    subject(:completed_scope) { Spree::Order.completed }

    it { expect(completed_scope).to     include(completed_order)  }
    it { expect(completed_scope).to_not include(incomplete_order) }
  end
end
