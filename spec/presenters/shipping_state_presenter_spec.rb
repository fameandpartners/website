require 'spec_helper'


describe ShippingStatePresenter do

  xit "should have specs"

  # TODO - ABSOLVE MYSELF OF THIS TERRIBLE SIN
  # describe 'order delivery state' do
  #
  #   let(:order) { double() }
  #
  #   let(:presenter) { described_class.new(order) }
  #
  #
  #   context 'incomplete' do
  #     let(:order) { double(:complete? => false) }
  #
  #     it 'should be ok' do
  #       expect(presenter.delivery_state).to eq 'incomplete'
  #     end
  #   end
  #
  #   context 'more than 2 days before due date' do
  #     let(:order) { double(:projected_delivery_date => 5.days.since) }
  #
  #     it 'should be ok' do
  #       expect(presenter.delivery_state).to eq 'ok'
  #     end
  #   end
  #
  #   context '1 days before due date' do
  #     before do
  #       expect(order).to receive(:projected_delivery_date).twice.and_return(1.days.since)
  #     end
  #
  #     it 'should be due' do
  #       expect(presenter.delivery_state).to eq 'due'
  #     end
  #   end
  #
  #   context '3 days after due date' do
  #     before do
  #       expect(order).to receive(:projected_delivery_date).twice.and_return(3.days.ago)
  #     end
  #
  #     it 'should be overdue' do
  #       expect(presenter.delivery_state).to eq 'overdue'
  #     end
  #   end
  #
  #   context '7 days after due date' do
  #     before do
  #       expect(order).to receive(:projected_delivery_date).twice.and_return(7.days.ago)
  #     end
  #
  #     it 'should be overdue' do
  #       expect(presenter.delivery_state).to eq 'urgent'
  #     end
  #   end
  #
  #   context 'overdue > 1 week' do
  #
  #     before do
  #       expect(order).to receive(:projected_delivery_date).twice.and_return(12.days.ago)
  #     end
  #
  #     it 'should be critical' do
  #       expect(presenter.delivery_state).to eq 'critical'
  #     end
  #
  #   end
  #
  # end
end
