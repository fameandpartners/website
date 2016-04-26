require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe ReceivingTicketAdd, :vcr do
      let(:savon_client) { SavonClient.new }
      let(:soap_method) { described_class.new(savon_client: savon_client) }

      describe 'creates a new receiving ticket' do
        context 'successfully creates' do
          pending
        end

        context 'fail to create' do
          pending
        end
      end
    end
  end
end
