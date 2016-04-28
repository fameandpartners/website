require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe GetStyleMasterProductAddStatus, :vcr do
      let(:savon_client) { SavonClient.new }
      let(:spree_variant) { build_stubbed(:dress_variant) }
      let(:soap_method) { described_class.new(savon_client: savon_client, spree_variant: spree_variant) }

      it 'gets status from a variant that is in WMS queue' do
        expect(soap_method.request.body).to eq({
                                                 :get_style_master_product_add_status_response =>
                                                   { :get_style_master_product_add_status_result =>
                                                       { :notifications =>
                                                           { :notification =>
                                                               { :error_code => '87',
                                                                 :severity   => 'PendingImport',
                                                                 :message    => 'Pending import' }
                                                           }
                                                       },
                                                     :@xmlns                                     => 'http://rex11.com/webmethods/' } })
      end
    end
  end
end
