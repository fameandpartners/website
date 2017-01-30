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
    before { allow_any_instance_of(ItemReturn).to receive(:set_currency_from_line_item) }

    it { is_expected.to validate_uniqueness_of(:uuid) }
  end
end
