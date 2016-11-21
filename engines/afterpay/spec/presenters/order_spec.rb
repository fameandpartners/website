require 'spec_helper'

describe Afterpay::Presenters::Order do
  let(:spree_order) { FactoryGirl.create(:complete_order_with_items) }
  let(:bill_address) { spree_order.bill_address }
  let(:bill_country) { bill_address.country }

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
end
