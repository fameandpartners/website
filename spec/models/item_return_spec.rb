require 'rails_helper'

RSpec.describe ItemReturn, type: :model do
  describe 'associations' do
    it {
      is_expected.to have_many(:events).
        class_name('ItemReturnEvent').
        with_foreign_key('item_return_uuid').
        with_primary_key('uuid')
    }

    it { is_expected.to belong_to(:line_item).class_name('Spree::LineItem').inverse_of(:item_return) }
    it { is_expected.to belong_to(:return_request).class_name('ReturnRequestItem').with_foreign_key(:request_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:uuid) }
  end

  describe 'scopes' do
    let!(:items_with_empty_status) { FactoryGirl.create_list(:item_return, 3, refund_status: nil) }
    let!(:items_with_incomplete_status) { FactoryGirl.create_list(:item_return, 3, refund_status: 'Some status') }
    let!(:items_with_complete_status) { FactoryGirl.create_list(:item_return, 3, refund_status: 'Complete') }

    describe '::incomplete' do
      it 'returns items with refund status which is null or not Complete' do
        scope = described_class.incomplete

        items_with_empty_status.each do |item|
          expect(scope).to include(item)
        end
        items_with_incomplete_status.each do |item|
          expect(scope).to include(item)
        end
        items_with_complete_status.each do |item|
          expect(scope).not_to include(item)
        end
      end
    end

    describe '::refund_queue' do
      it 'returns incomplete items marked as bulk refund' do
        items_with_empty_status.last.update_attribute(:bulk_refund, true)
        items_with_incomplete_status.last.update_attribute(:bulk_refund, true)
        items_with_complete_status.last.update_attribute(:bulk_refund, true)

        scope = described_class.refund_queue

        expect(scope).to include(items_with_empty_status.last)
        expect(scope).to include(items_with_incomplete_status.last)

        expect(scope).not_to include(items_with_empty_status.first)
        expect(scope).not_to include(items_with_incomplete_status.first)

        items_with_complete_status.each do |item|
          expect(scope).not_to include(item)
        end
      end
    end
  end
end
