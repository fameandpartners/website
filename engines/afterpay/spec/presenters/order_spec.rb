require 'spec_helper'

describe Afterpay::Presenters::Order do
  let(:spree_order) { FactoryGirl.create(:complete_order_with_items) }
  let(:bill_address) { spree_order.bill_address }
  let(:bill_country) { bill_address.country }
  let(:ship_address) { spree_order.ship_address }

  subject { described_class.new(spree_order: spree_order) }

  describe "forwardable" do
    it "wraps spree order" do
      %i(total currency email number).each do |method|
        subject_should_delegate(method: method, object: spree_order)
      end
    end

    it "wraps bill address" do
      %i(phone firstname lastname).each do |method|
        subject_should_delegate(method: method, object: bill_address)
      end
    end

    def subject_should_delegate(method:, object:)
      expect(subject.send(method)).to eq(object.send(method))
    end
  end

  shared_examples_for :states do
    it "fetches abbr from state if presents" do
      expect(subject.send(state_method)).not_to be_nil
      expect(subject.send(state_method)).to eq(address.state.abbr)
    end

    it "gets state_name from address if state is blank" do
      address.state = nil
      address.state_name = "custom_state"
      address.save

      expect(subject.send(state_method)).not_to be_nil
      expect(subject.send(state_method)).to eq("custom_state")
    end
  end

  describe "#billing_state" do
    let(:address) { bill_address }
    let(:state_method) { :billing_state }

    it_behaves_like :states
  end

  describe "#shipping_state" do
    let(:address) { ship_address}
    let(:state_method) { :shipping_state }

    it_behaves_like :states
  end
end
