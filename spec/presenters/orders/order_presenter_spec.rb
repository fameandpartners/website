require 'spec_helper'

module Orders
  RSpec.describe OrderPresenter do
    describe 'delegated attributes' do
      let(:order) { build_stubbed(:spree_order,
                                  completed_at: DateTime.parse('10/10/2015 10:10:10 UTC'),
                                  email: 'loroteiro@silvestre.com',
                                  id: 12321,
                                  number: 'R123123123',
                                  state: 'complete',
      ) }
      let(:presenter) { described_class.new(order, []) }

      it { expect(presenter.completed_at).to eq(DateTime.parse('10/10/2015 10:10:10 UTC')) }
      it { expect(presenter.email).to eq('loroteiro@silvestre.com') }
      it { expect(presenter.id).to eq(12321) }
      it { expect(presenter.number).to eq('R123123123') }
      it { expect(presenter.state).to eq('complete') }
    end
  end
end
