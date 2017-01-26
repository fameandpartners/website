require 'spec_helper'

RSpec.describe ItemReturn do
  it { is_expected.to validate_presence_of(:order_paid_currency) }
end
