require 'spec_helper'

RSpec.describe FabricationCalculator do

  let(:line_item_id)   { rand 1_000_000 }
  let(:creation_event) { FabricationEvent.creation.create!( line_item_id: line_item_id ) }

  subject(:created_fabrication) { Fabrication.find_by_line_item_id line_item_id }

  describe 'creation' do
    before do
      creation_event
      FabricationCalculator.new(created_fabrication).run.save!
    end

    it { expect(created_fabrication.line_item_id).to eq line_item_id }
    it { expect(created_fabrication.state).to        eq 'new' }
  end

  describe 'state_change' do

    let(:user_name)     { 'Billy Bob' }
    let(:user_id)       { rand 1_000  }
    let(:changed_state) { Fabrication::STATES.keys.sample.to_s }

    let(:state_change_event) do
      created_fabrication.events.state_change.create!(
        user_id:   user_id,
        user_name: user_name,
        state:     changed_state
      )
    end

    before do
      creation_event
      state_change_event

      FabricationCalculator.new(created_fabrication).run.save!

      created_fabrication.reload
    end

    it { expect(state_change_event).to be_valid }

    it { expect(created_fabrication.line_item_id).to eq line_item_id  }
    it { expect(created_fabrication.state).to        eq changed_state }

    it { expect(state_change_event.user_id).to       eq user_id       }
    it { expect(state_change_event.user_name).to     eq user_name     }
    it { expect(state_change_event.state).to         eq changed_state }
  end
end
