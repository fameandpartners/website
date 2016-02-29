require 'spec_helper'

RSpec.describe Activity, :type => :model do

  describe 'validation' do
    let(:allowed_actions) { %w{viewed purchased added_to_cart added_to_wishlist quiz_started} }
    it { is_expected.to validate_inclusion_of(:action).in_array(allowed_actions) }
  end

  describe '.log_product_viewed' do
    let(:product)       { double('Spree::Product', id: 777) }
    let(:session_key)   { SecureRandom.urlsafe_base64(32) }
    let(:user)          { double('User', id: 403, class: 'COOLUSER') }
    let(:subject_scope) { described_class.where(owner_type: 'Spree::Product', owner_id: 777) }

    subject(:logged_activity) { subject_scope.first }

    context 'appending new view events' do
      it 'creates one activity object' do
        described_class.log_product_viewed(product, session_key, user)
        expect(subject_scope.count).to eq 1
      end

      it 'creates multiple activity objects' do
        described_class.log_product_viewed(product, session_key, user)
        described_class.log_product_viewed(product, session_key, user)
        expect(subject_scope.count).to eq 2
      end
    end

    context 'attributes' do
      before do
        described_class.log_product_viewed(product, session_key, user)
      end

      it { expect(logged_activity.action).to      eq('viewed') }
      it { expect(logged_activity.actor_id).to    eq(403) }
      it { expect(logged_activity.actor_type).to  eq('COOLUSER') }
      it { expect(logged_activity.owner_id).to    eq(777) }
      it { expect(logged_activity.owner_type).to  eq('Spree::Product') }
      it { expect(logged_activity.number).to      eq(1) }
      it { expect(logged_activity.session_key).to eq(session_key) }
    end
  end
end
