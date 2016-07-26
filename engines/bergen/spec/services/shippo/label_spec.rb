require 'spec_helper'

require_relative '../../support/return_item_ready_to_process_context'

module Shippo
  RSpec.describe Label, type: :operation do
    include_context 'return item ready to process'

    let(:label) { described_class.new(return_request_item) }

    context 'Create correct label' do
      it do
        label_results = label.create
        expect(label_results[:status]).to eq('SUCCESS')
        expect(label_results[:label_url]).not_to be_empty
        expect(label_results[:tracking_number]).to match(/^[0-9]/)
      end
    end

    let(:label_wrong) { described_class.new(return_request_item_wrong) }

    context 'Create label from order with incorrect address' do
      it do
        expect { label_wrong.create }.to raise_error(Shippo::APIError)
      end
    end

  end
end
