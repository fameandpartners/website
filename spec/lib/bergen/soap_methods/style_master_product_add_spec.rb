require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe StyleMasterProductAdd, :vcr do
      let(:savon_client) { SavonClient.new }
      let(:spree_variant) { build_stubbed(:dress_variant) }
      let(:soap_method) { described_class.new(savon_client: savon_client, spree_variants: [spree_variant]) }

      it 'adds some variants to WMS queue' do
        expect(soap_method.result).to eq({ error_code: '0', severity: 'Success', message: 'Data saved successfully' })
      end
    end
  end
end
