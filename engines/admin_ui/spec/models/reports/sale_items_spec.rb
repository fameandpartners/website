require 'spec_helper'
require 'reports/sale_items'

module Reports
  RSpec.describe SaleItems do

    it { expect{SaleItems.new}.to raise_error(ArgumentError) }

    it { expect{ SaleItems.new(from: Date.today, to: Date.today)}.to_not raise_error(ArgumentError) }
  end
end
