require 'spec_helper'

describe FacebookData, type: :model do
  it { is_expected.to belong_to(:spree_user).class_name('Spree::User') }
  it { is_expected.to serialize(:value) }

  it { is_expected.to validate_presence_of(:spree_user) }
end
