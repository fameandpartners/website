require 'spec_helper'

module Bergen
  module Presenters
    RSpec.describe ItemReturnPresenter, type: :presenter do
      describe 'item acceptance' do
        let(:damaged_item) { build_stubbed(:item_return, bergen_damaged_quantity: 1, bergen_actual_quantity: 0) }
        let(:accepted_item) { build_stubbed(:item_return, bergen_damaged_quantity: 0, bergen_actual_quantity: 1) }

        let(:damaged_item_presenter) { described_class.new(item_return: damaged_item) }
        let(:accepted_item_presenter) { described_class.new(item_return: accepted_item) }

        describe '#rejected?' do
          it 'returns if a parcel received any damaged quantity' do
            expect(damaged_item_presenter.rejected?).to be_truthy
            expect(accepted_item_presenter.rejected?).to be_falsy
          end
        end

        describe '#accepted?' do
          it 'returns if a parcel was successfully received' do
            expect(damaged_item_presenter.accepted?).to be_falsy
            expect(accepted_item_presenter.accepted?).to be_truthy
          end
        end
      end
    end
  end
end
