require 'spec_helper'

describe Spree::User, type: :model do
  it { is_expected.to delegate_method(:value).to(:facebook_data).with_prefix(true) }

  describe '#facebook_data_value' do
    let(:user) { create(:spree_user) }

    it 'creates facebook_data if needed' do
      expect(FacebookData.count).to eq(0)
      user.facebook_data_value
      expect(FacebookData.count).to eq(1)
    end

    context 'sets facebook data hash' do
      before(:each) do
        user.facebook_data_value[:something] = 'in the way'
        user.save
      end

      it 'returns facebook data hash' do
        result = user.facebook_data_value[:something]
        expect(result).to eq('in the way')
      end
    end
  end

  describe "#subscriptions" do
    context "#create" do
      it "runs for new record" do
        user = build(:spree_user)
        user.newsletter = true

        expect(user).to receive(:create_marketing_subscriber)
        user.run_callbacks(:create)
      end

      it "don't run anything if we have no permission" do
        user = build(:spree_user)
        user.newsletter = false

        expect(user).not_to receive(:create_marketing_subscriber)
        user.run_callbacks(:create)
      end
    end

    context "#update" do
      it "on record update" do
        user = build(:spree_user)
        user.newsletter = true

        expect(user).to receive(:update_marketing_subsriber)
        user.run_callbacks(:update)
      end

      it "don't run anything if we have no permission" do
        user = build(:spree_user)
        user.newsletter = false

        expect(user).not_to receive(:update_marketing_subsriber)
        user.run_callbacks(:update)
      end
    end
  end
end
