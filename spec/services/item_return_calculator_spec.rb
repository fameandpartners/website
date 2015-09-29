require 'spec_helper'

RSpec.describe ItemReturnCalculator do
  let(:line_item_id)   { rand 1_000_000 }

  let(:creation_event) { ItemReturnEvent.creation.create!( line_item_id: line_item_id ) }
  subject(:created_item_return) { ItemReturn.find_by_line_item_id line_item_id }

  describe 'creation' do
    before do
      creation_event
      described_class.new(created_item_return).run.save!
    end

    it { expect(created_item_return.line_item_id).to eq line_item_id }
    it { expect(created_item_return.comments).to eq "" }
  end

  describe '#advance_receive_item' do

    let(:user)          { Faker::Internet.email }
    let(:received_date) { rand(14).days.ago.to_date }

    before do
      creation_event
      created_item_return.events.receive_item.create!({user: user, received_on: received_date, location: 'AU' })
      described_class.new(created_item_return).run.save!
      created_item_return.reload
    end

    it('stores the date') do
      expect(created_item_return.received_on).to eq received_date
    end
    it('sets the status to "received"') do
      expect(created_item_return.acceptance_status).to eq 'received'
    end

    it('maps location to received_location') do
      expect(created_item_return.received_location).to eq 'AU'
    end
  end

  describe '#advance_approve' do
    let(:user)          { Faker::Internet.email }

    before do
      creation_event
      created_item_return.events.approve.create!({user: user, comment: "Cool Stuff"})
      created_item_return.events.approve.create!({user: user, comment: "Approved Again"})
      described_class.new(created_item_return).run.save!
      created_item_return.reload
    end

    it('updates the comment') do
      expect(created_item_return.comments).to eq "Cool Stuff\nApproved Again\n"
    end
    it('sets the status to "approved"') do
      expect(created_item_return.acceptance_status).to eq 'approved'
    end
  end

  describe '#advance_rejection' do
    let(:user)          { Faker::Internet.email }

    before do
      creation_event
      created_item_return.events.rejection.create!({user: user, comment: "NOPE"})
      described_class.new(created_item_return).run.save!
      created_item_return.reload
    end

    it('updates the comment') do
      expect(created_item_return.comments).to eq "NOPE\n"
    end
    it('sets the status to "rejected"') do
      expect(created_item_return.acceptance_status).to eq 'rejected'
    end
  end
end

