require 'spec_helper'

RSpec.describe ItemReturn do
  describe 'validation' do
    describe 'order_paid_currency' do
      it { is_expected.to validate_presence_of :order_paid_currency }
    end
  end
end
