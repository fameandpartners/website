require 'spec_helper'

RSpec.describe ItemReturnCalculator do
  before(:each) do
    @user  = FactoryGirl.create(:spree_user)
    @order = FactoryGirl.create(:complete_order_with_items, id: 67, user_id: @user.id)

    shipment = FactoryGirl.build(:simple_shipment, order: @order)
    FactoryGirl.create(:inventory_unit, variant: @order.line_items.last.product.master, order: @order, shipment: shipment)
  end

  let(:user) { Faker::Internet.email }
  let(:line_item) { @order.line_items.first }
  let(:creation_event) { ItemReturnEvent.creation.create!( line_item_id: line_item.id ) }
  subject(:created_item_return) { ItemReturn.find_by_line_item_id line_item.id }

  describe 'creation' do
    before do
      creation_event
      described_class.new(created_item_return).run.save!
    end

    it { expect(created_item_return.line_item_id).to eq line_item.id }
    it { expect(created_item_return.comments).to eq "" }
  end

  describe '#advance_receive_item' do

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

  describe '#advance_bergen_asn_created' do
    before do
      creation_event
      created_item_return.events.bergen_asn_created.create!({asn_number: 'ABC123-BERGEN'})
      created_item_return.reload
    end

    it { expect(created_item_return.bergen_asn_number).to eq('ABC123-BERGEN') }
  end

  describe '#advance_bergen_asn_received' do
    before do
      creation_event

      expect(Bergen::Operations::ReceiveBergenParcel).to receive_message_chain(:new, :process)
    end

    context 'received damaged items' do
      before do
        created_item_return.events.bergen_asn_received.create!({actual_quantity: 0, damaged_quantity: 1})
        created_item_return.reload
      end

      it 'rejects the item' do
        expect(created_item_return.bergen_actual_quantity).to eq(0)
        expect(created_item_return.bergen_damaged_quantity).to eq(1)
      end
    end

    context 'successfully received items' do
      before do
        created_item_return.events.bergen_asn_received.create!({actual_quantity: 1, damaged_quantity: 0})
        created_item_return.reload
      end

      it 'accept items' do
        expect(created_item_return.bergen_actual_quantity).to eq(1)
        expect(created_item_return.bergen_damaged_quantity).to eq(0)
      end
    end
  end

  describe '#advance_refund' do
    let(:pin_payment) { double(:pin_payment) }
    let(:created_at) { Time.parse('2016-05-01').utc.to_s }
    let(:refund_response) { double(:response, success?: true, params: { 'response' => { 'token' => 'response_token', 'created_at' => created_at } }) }

    before do
      allow(Spree::Gateway::Pin).to receive(:where).and_return([pin_payment])
      creation_event
      allow_any_instance_of(ItemReturn).to receive(:order_payment_ref).and_return('order_payment_ref')
    end

    it "calls Pins refund entry point" do
        expect(pin_payment).to receive(:refund).with(4039, 'order_payment_ref').and_return(refund_response)

        created_item_return.events.refund.create!({refund_method: 'Pin', refund_amount: 40.39, user: user})
        created_item_return.reload

        expect(created_item_return.refund_status).to eq('Complete')
        expect(created_item_return.refund_method).to eq('Pin')
        expect(created_item_return.refund_amount).to eq(4039)
        expect(created_item_return.refund_ref).to eq('response_token')
        expect(created_item_return.refunded_at.utc.strftime('%Y-%m-%d %H:%M:%S UTC')).to eq(created_at)
    end

    xit "notifies user with customer.io" do
      promise = double(:promise)
      expect(RefundMailer).to receive(:notify_user).and_return(promise)
      expect(promise).to receive(:deliver)
      allow(pin_payment).to receive(:refund).and_return(refund_response)

      created_item_return.events.refund.create!({refund_method: 'Pin', refund_amount: 40, user: user})
    end
  end
end

