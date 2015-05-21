require 'rails_helper'

module Admin
  RSpec.describe BulkOrderUpdate, :type => :model do

    describe '#deletable?' do
      let(:line_item_updates) { build_list :line_item_update, 2, state: item_states }

      subject(:bulk_order_update) do
        bu = described_class.new
        bu.line_item_updates = line_item_updates
        bu
      end

      describe 'allows when items have no state' do
        let(:item_states) { nil }
        it { is_expected.to be_deletable }
      end

      describe 'restricts when items have state' do
        let(:item_states) { :some_state  }
        it { is_expected.not_to be_deletable }
      end
    end
  end
end
