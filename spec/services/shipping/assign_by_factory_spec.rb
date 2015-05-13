require 'spec_helper'

module Shipping
  RSpec.describe AssignByFactory do
    # This is quite smelly, code and design-wise.
    it 'groups #units_by_factory' do
      unit1, unit2, unit3 = double('unit1'), double('unit2'), Object.new
      allow(unit1).to receive_message_chain(:variant, :product, :factory).and_return(:f1)
      allow(unit2).to receive_message_chain(:variant, :product, :factory).and_return(:f2)

      order = double('order', inventory_units: [unit1, unit2, unit3])

      assigner = described_class.new(order)

      expect(assigner.units_by_factory).to eq(f1: [unit1], f2: [unit2], unknown: [unit3])
    end
  end
end
