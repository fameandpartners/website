require 'spec_helper'

RSpec.describe Discount, type: :model do
  it { is_expected.to validate_presence_of :discountable_id }
  it { is_expected.to validate_presence_of :discountable_type }
  it { is_expected.to validate_presence_of :sale_id }

  it { is_expected.to validate_uniqueness_of(:discountable_id)
                        .scoped_to(:discountable_type, :sale_id) }
end
