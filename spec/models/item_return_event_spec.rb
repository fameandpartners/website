require 'rails_helper'

RSpec.describe ItemReturnEvent, :type => :model do

  describe 'creation' do
    subject(:event) { ItemReturnEvent.creation.new }

    it { is_expected.to validate_presence_of :line_item_id }
  end

  describe 'return_requested' do
    # A bunch of attributes. No actual validations. Tests would live on calculator
  end

  describe 'receive_item' do
    subject(:event) { ItemReturnEvent.receive_item.new }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :location }
    it { is_expected.to validate_inclusion_of(:location).in_array(%w[AU US]) }
    it { is_expected.to validate_presence_of :received_on }
  end

  describe 'approve' do
    subject(:event) { ItemReturnEvent.approve.new }

    it { is_expected.to validate_presence_of :user }
  end

  describe 'rejection' do
    subject(:event) { ItemReturnEvent.rejection.new }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :comment }
  end

  describe 'record refund' do
    subject(:event) { ItemReturnEvent.record_refund.new }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :refund_method }
    it { is_expected.to validate_presence_of :refund_amount }
    it { is_expected.to validate_presence_of :refunded_at }
  end

  describe 'refund' do
    subject(:event) { ItemReturnEvent.refund.new }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :refund_method }
    it { is_expected.to validate_presence_of :refund_amount }
  end

  describe 'factory fault' do

    subject(:event) { ItemReturnEvent.factory_fault.new }
    let!(:item_return) { create(:item_return, uuid: event.item_return_uuid) }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :factory_fault }
    it 'updates item_returns.factory_fault to true if true' do
      event.user = Faker::Internet.email
      event.factory_fault = true
      event.factory_fault_reason = "Test Reason"
      event.save!
      item_returns = ItemReturn.find(item_return.id)
      expect(item_returns.factory_fault).to be true
    end

    it 'updates item_returns.factory_fault to false if false' do
      event.user = Faker::Internet.email
      event.factory_fault = 'false'
      event.save!
      item_returns = ItemReturn.find(item_return.id)
      expect(item_returns.factory_fault).to be false
    end
  end

  describe 'bergen asn created' do
    subject(:event) { ItemReturnEvent.bergen_asn_created.new }

    it { is_expected.to validate_presence_of :asn_number }
  end
end
