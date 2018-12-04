require 'spec_helper'

module Spree
  RSpec.describe LineItem do
    describe '#delivery_period' do
      xit "delegates delivery period to policy" do
        delivery_period = double(:delivery_period)
        is_expected.to receive(:delivery_period_policy).and_return(double(:policy, delivery_period: delivery_period))

        expect(subject.delivery_period).to eq(delivery_period)
      end
    end
  end
end
