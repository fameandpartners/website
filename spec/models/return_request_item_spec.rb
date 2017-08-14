require 'spec_helper'

describe ReturnRequestItem do

  describe 'validation' do
    it { is_expected.to validate_presence_of :line_item }
    it { is_expected.to validate_presence_of :action    }
    it { is_expected.to validate_inclusion_of(:action).in_array(%w[keep exchange return]) }

    context 'requiring reasons' do
      subject { described_class.new action: action }

      %w[return exchange].each do |action_type|
        context "do for #{action_type}s" do
          let(:action)  { action_type }

          it { is_expected.to validate_presence_of :reason_category }
        end
      end

      context 'not when keeping' do
        let(:action)  { 'keep' }

        it { is_expected.to_not validate_presence_of :reason_category }     
      end
    end
  end

  let(:line_item) { stub_model(Spree::LineItem) }
  let(:order)      { stub_model(Spree::Order) }
  let(:action)     { nil }

  subject(:return_request_item) { ReturnRequestItem.new(:line_item => line_item, :action => action) }

  it{ is_expected.to be_keep }
  it{ is_expected.to be_valid }

  context 'when return or exchanged' do
    let(:action)     { 'return' }

    it 'validates reasons' do
      expect(return_request_item).to be_invalid

      return_request_item.reason_category = 'OH NOES'
      return_request_item.reason = 'BORKED'
      expect(return_request_item).to be_valid
    end

  end
end
