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

    describe '#projected_delivery_date' do
      let(:order)         { instance_spy('Spree::Order', :completed? => completed, :line_items =>[])  }
      subject(:presenter) { described_class.new(order, [])  }

      context 'incomplete orders' do
        let(:completed) { false }
        it 'short circuits' do
          expect(order).to_not have_received(:projected_delivery_date)
          expect(presenter.projected_delivery_date).to be_nil
        end
      end

      context 'fast making promo' do
        let(:completed) { true }
        before do
          allow(presenter).to receive(:promo_codes).and_return(['[birthdaygirl] Birthday Promotion'])
        end
        it 'is a fast making promo' do
          expect(presenter).to be_fast_making_promo
        end
      end

      context 'complete orders' do
        let(:completed) { true }
        let(:known_date) { Date.today }

        it 'delegates to order' do
          allow(order).to receive_message_chain(:projected_delivery_date, :try)
                            .and_return(known_date)

          expect(presenter.projected_delivery_date).to eq known_date
        end

        it 'falls back to OrderProjectedDeliveryDatePolicy' do
          allow(order).to receive_message_chain(:projected_delivery_date, :try).and_return(nil)

          allow_any_instance_of(Policies::OrderProjectedDeliveryDatePolicy).to receive(:delivery_date).and_return(known_date)

          expect(presenter.projected_delivery_date).to eq known_date
        end
      end
    end
  end
end
