require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe StyleMasterProductAdd, :vcr do
      let(:savon_client) { SavonClient.new }
      let(:spree_variant) { build_stubbed(:dress_variant) }
      let(:soap_method) { described_class.new(savon_client: savon_client, spree_variant: spree_variant) }

      it 'adds a variant to WMS queue' do
        expect(soap_method.request.body).to eq({
                                                 :style_master_product_add_response =>
                                                   { :style_master_product_add_result =>
                                                       { :notifications =>
                                                           { :notification =>
                                                               { :error_code => '0',
                                                                 :severity   => 'Success',
                                                                 :message    => 'Data saved successfully' }
                                                           }
                                                       },
                                                     :@xmlns                          => 'http://rex11.com/webmethods/'
                                                   }
                                               })
      end
    end
  end
end
