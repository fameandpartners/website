require 'rails_helper'

RSpec.describe Moodboard, :type => :model do
  context 'validations' do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_inclusion_of(:purpose).in_array(%w( default wedding )) }
  end

  describe '.default_or_create' do
    describe 'cannot create when not chained to user' do
      subject(:without_user) { described_class.default_or_create }

      it { is_expected.to_not be_valid }
      it { expect(without_user.purpose).to  eq 'default' }
      it { expect(without_user.name).to     eq 'Wishlist' }
    end

    describe 'always returns the same db item per user' do
      let(:user)        { create :spree_user }
      let(:first_time)  { user.moodboards.default_or_create }
      let(:second_time) { user.moodboards.default_or_create }

      it do
        expect(first_time.id).to eq(second_time.id)
      end

      it { expect(first_time).to be_valid }
      it { expect(second_time).to be_valid }

      it { expect(first_time.purpose).to  eq 'default' }
      it { expect(second_time.purpose).to eq 'default' }

      it { expect(first_time.name).to  eq 'Wishlist' }
      it { expect(second_time.name).to eq 'Wishlist' }
    end
  end

  xdescribe '#add_item'
end
