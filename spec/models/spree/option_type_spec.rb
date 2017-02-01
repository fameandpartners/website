require 'spec_helper'

describe Spree::OptionType, type: :model do
  describe 'scopes' do
    describe '.color' do
      let!(:option_type) { FactoryGirl.create(:option_type, name: 'dress-color') }
      subject { described_class.color }

      it { is_expected.to eq(option_type) }
    end

    describe '.size' do
      let!(:option_type) { FactoryGirl.create(:option_type, name: 'dress-size') }
      subject { described_class.size }

      it { is_expected.to eq(option_type) }
    end
  end
end
