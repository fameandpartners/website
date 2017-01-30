require 'spec_helper'

RSpec.describe ItemReturn do
  describe 'validation' do
    describe 'order_paid_currency' do
      before { allow(subject).to receive(:set_currency_from_line_item) }

      it { is_expected.to validate_presence_of :order_paid_currency }
    end
  end
end
