require 'spec_helper'

describe Spree::User, type: :model do
  let(:user) { described_class.new }

  context '#style_profile' do
    it 'can have empty style profile' do
      expect(user.style_profile).to eq(nil)
    end
  end
end
