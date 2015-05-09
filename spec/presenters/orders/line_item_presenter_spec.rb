require 'spec_helper'

module Orders
  RSpec.describe LineItemPresenter do

    describe 'delegates to LineItem' do

      let(:item) do
        FactoryGirl.build(:line_item,
                          :id       => 300,
                          :price    => 999,
                          :quantity => 3,
        )
      end

      let(:order)         { instance_spy 'Spree::Order' }
      subject(:presenter) { described_class.new(item, order) }

      it('#id')            { expect(subject.id).to eq 300     }
      it('#display_price') { expect(subject.price).to eq 999  }
      it('#quantity')      { expect(subject.quantity).to eq 3 }
    end
  end
end
