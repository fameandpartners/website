require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe GetInventory, :vcr do
      let(:savon_client) { SavonClient.new }
      let(:soap_method) { described_class.new(savon_client: savon_client) }

      # This will always return empty for staging env
      it 'returns current inventory' do
        expect(soap_method.request.body).to eq({
                                                 get_inventory_response: {
                                                   get_inventory_result: {
                                                     notifications: nil,
                                                     inventory:     nil },
                                                   :@xmlns               => 'http://rex11.com/webmethods/'
                                                 }
                                               })
      end
    end
  end
end
