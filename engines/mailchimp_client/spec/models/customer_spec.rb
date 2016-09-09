require 'spec_helper'

RSpec.describe MailChimp::Customer, type: :model do

  let(:user) { build(:spree_user) }

  before do
    allow(user).to receive(:id).and_return(1)
    allow(user).to receive(:email).and_return('user1@gmail.com')
    allow(user).to receive(:first_name).and_return('first_name_1')
    allow(user).to receive(:last_name).and_return('last_name_1')
  end

  describe('::Exists', :vcr) do

    it('should check if customer exists') do
      result = described_class::Exists.(user)
      expect(result).to eql(false)
    end
  end

  describe('::Create', :vcr) do

    it('should create customer') do
      result = described_class::Create.(user)
      expect(result).to eql(true)
    end
  end
end
