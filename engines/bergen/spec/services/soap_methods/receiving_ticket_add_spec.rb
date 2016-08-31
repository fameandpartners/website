require 'spec_helper'

require_relative '../../support/return_item_ready_to_process_context'

module Bergen
  module SoapMethods
    RSpec.describe ReceivingTicketAdd, :vcr do
      include_context 'return item ready to process'

      let(:savon_client) { SavonClient.new }
      let(:soap_method) { described_class.new(
        savon_client: savon_client,
        return_request_item: return_request_item,
        tracking_number: 'tracking_number'
      ) }

      describe 'creates a new receiving ticket' do
        context 'successfully creates' do
          it do
            expect(soap_method.result).to eq({
                                               receiving_ticket_id: 'WHRTN1044584'
                                             })
          end
        end

        context 'fail to create' do
          # TODO No fail scenario yet
        end
      end
    end
  end
end
