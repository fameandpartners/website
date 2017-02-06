require 'spec_helper'

require_relative '../../support/return_item_ready_to_process_context'

module Bergen
  module Presenters
    RSpec.describe ItemReturnPresenter, type: :presenter do
      let(:item_return) { create(:item_return,
                                 order_number:         '1001001SOS',
                                 bergen_asn_number:    'BERGENASN',
                                 product_name:         'Super Product Woot',
                                 product_style_number: 'Style 123',
                                 product_size:         'US10/AU14',
                                 product_colour:       'Red'
      ) }
      let(:presenter) { described_class.new(item_return: item_return) }

      describe 'attribute delegation' do
        it { expect(presenter.order_number).to eq('1001001SOS') }
        it { expect(presenter.bergen_asn_number).to eq('BERGENASN') }
        it { expect(presenter.product_name).to eq('Super Product Woot') }
        it { expect(presenter.product_style_number).to eq('Style 123') }
        it { expect(presenter.product_size).to eq('US10/AU14') }
        it { expect(presenter.product_colour).to eq('Red') }
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

      describe 'URL helpers' do
        describe '#admin_ui_mail_url' do
          let(:item_return) { build_stubbed(:item_return, id: 101) }
          let(:presenter) { described_class.new(item_return: item_return) }

          it 'returns the admin UI url for the given item return' do
            expect(presenter.admin_ui_mail_url).to eq('http://fameandpartners.test/fame_admin/item_returns/101')
          end
        end
      end

      describe 'order attributes' do
        include_context 'return item ready to process'

        it { expect(presenter.order_date).to eq(DateTime.parse('10/10/2015 12:34:00 UTC')) }
        it { expect(presenter.price).to eq('$123.45') }
        it { expect(presenter.customer_address).to eq('1226 Factory Place, Los Angeles, California, 90013, United States of America') }
      end

      describe 'Global SKU attributes' do
        include_context 'return item ready to process'

        it { expect(presenter.height).to eq('petite') }
        it { expect(presenter.global_upc).to eq(10001) }
        it { expect(presenter.customization).to eq('Super Custom') }
      end
    end
  end
end
