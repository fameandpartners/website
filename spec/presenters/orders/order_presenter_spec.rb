require 'spec_helper'

module Orders
  RSpec.describe OrderPresenter do
    describe '#projected_delivery_date' do
      let(:order)         { instance_spy('Spree::Order', :completed? => completed)  }
      subject(:presenter) { described_class.new(order)  }

      context 'incomplete orders' do
        let(:completed) { false }
        it 'short circuits' do
          expect(order).to_not have_received(:projected_delivery_date)
          expect(presenter.projected_delivery_date).to be_nil
        end
      end

      context 'fast making promo' do
        before do
          allow(presenter).to receive(promo_codes).and_return(['[birthdaygirl] Birthday Promotion'])
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
