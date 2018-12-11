require 'spec_helper'

module Orders
  RSpec.describe TaxPresenter do
    let(:order) { build_stubbed(:spree_order, currency: 'USD') }
    let(:tax) { build_stubbed(:adjustment, amount: 123.45, label: 'Super Tax') }

    let(:presenter) { described_class.new(spree_adjustment: tax, spree_order: order) }

    describe 'delegated attributes' do
      it { expect(presenter.label).to eq('Super Tax') }
    end

    describe '#display_total' do
      it { expect(presenter.display_total).to eq('$123.45') }
    end

    describe '#to_h' do
      it { expect(presenter.to_h).to eq({ label: 'Super Tax', display_total: '$123.45' }) }
    end
  end
end
