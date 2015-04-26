require 'spec_helper'

RSpec.describe FabricationEvent, :type => :model do

  describe 'creation' do
    subject(:event) { FabricationEvent.creation.new }

    it do
      expect(event).to validate_presence_of :line_item_id
    end
  end

  describe 'state_change' do
    subject(:event) { FabricationEvent.state_change.new }

    let(:known_states) {
      %w(purchase_order_placed
        purchase_order_confirmed
        fabric_assigned
        style_cut
        make
        qc
        shipped
        customer_feedback_required
      ) }

    it do
      expect(event).to validate_presence_of :user_id
      expect(event).to validate_presence_of :user_name
      expect(event).to validate_presence_of :state
      expect(event).to validate_inclusion_of(:state).in_array(known_states)
    end
  end
end
