require 'spec_helper'

require_relative '../../support/return_item_ready_to_process_context'

module Shippo
  RSpec.describe Label, :vcr, type: :operation do
    include_context 'return item ready to process'

    context 'Create correct label' do
      let(:label) { described_class.new(return_request_item) }

      it do
        label_results = label.create
        expect(label_results[:status]).to eq('SUCCESS')
        expect(label_results[:label_url]).not_to be_empty
        expect(label_results[:tracking_number]).to eq('9205590164917300831564')
      end
    end

    context 'Create label from order with incorrect address' do
      let(:ship_address) { build(:address, firstname: 'Anna', lastname: 'Smit',
                                       address1: 'bla-bla-bla', address2: '',
                                       zipcode: '90013', city: 'Los Angeles', state: state,
                                       email: '') }
      let(:label_wrong) { described_class.new(return_request_item) }

      it do
        expect { label_wrong.create }.to raise_error(Shippo::APIError)
      end
    end

  end
end
