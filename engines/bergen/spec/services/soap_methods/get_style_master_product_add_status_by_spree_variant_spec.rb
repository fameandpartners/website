require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe GetStyleMasterProductAddStatusBySpreeVariant, :vcr do
      let(:savon_client) { SavonClient.new }
      let(:spree_variant) { build_stubbed(:dress_variant, id: 10) }
      let!(:spree_global_sku) { GlobalSku.create(variant: spree_variant) }
      let(:soap_method) { described_class.new(savon_client: savon_client, spree_variant: spree_variant) }

      it 'gets status from a variant that is in WMS queue' do
        expect(soap_method.result).to eq({ error_code: '0', severity: 'Success', message: 'Success' })
      end
    end
  end
end
