require 'spec_helper'

module Bergen
  module Presenters
    RSpec.describe ItemReturnPresenter, type: :presenter do
      describe 'attribute delegation' do
        let(:item_return) { build_stubbed(:item_return, order_number: '1001001SOS') }
        let(:presenter) { described_class.new(item_return: item_return) }

        it do
          expect(presenter.order_number).to eq('1001001SOS')
        end
      end

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

      describe '#admin_ui_mail_url' do
        let(:item_return) { build_stubbed(:item_return, id: 101) }
        let(:presenter) { described_class.new(item_return: item_return) }

        it 'returns the admin UI url for the given item return' do
          expect(presenter.admin_ui_mail_url).to eq('http://fameandpartners.test/fame_admin/item_returns/101')
        end
      end
    end
  end
end
