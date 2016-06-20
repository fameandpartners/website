require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe GetReceivingTicketObjectByTicketNo, :vcr do
      let(:savon_client) { SavonClient.new }
      let(:item_return) { build(:item_return, bergen_asn_number: 'WHRTN915384') }
      let(:return_request_item) { build_stubbed(:return_request_item, item_return: item_return) }

      let(:soap_method) { described_class.new(savon_client: savon_client, return_request_item: return_request_item) }

      it 'gets status from a return request item that is in WMS queue' do
        expect(soap_method.result).to eq({:receiving_status=>"Draft", :receiving_status_code=>"100", :created_date=>"5/17/2016 2:57:42 PM", :shipmentitemslist=>{:style=>"4b141", :color=>"navy", :upc=>"28615", :size=>"us2/au6", :expected_quantity=>"1", :actual_quantity=>"0", :damaged_quantity=>"0", :unit_cost=>"0", :product_msrp=>"189", :shipment_type=>"NA", :return_reason_code=>{:@xmlns=>"http://rex11.com/swpublicapi/ReceivingTicketItems.xsd"}, :@xmlns=>"http://rex11.com/swpublicapi/ReceivingTicket.xsd"}, :shipment_typelist=>"NA", :warehouse=>"BERGEN LOGISTICS NJ2", :expected_date=>"5/10/2016", :supplier_details=>{:company_name=>"Fame & Partners", :address1=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :address2=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :city=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :state=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :zip=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :country=>"United States", :non_us_region=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :phone=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :fax=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :email=>{:@xmlns=>"http://rex11.com/swpublicapi/CustomerOrder.xsd"}, :@xmlns=>"http://rex11.com/swpublicapi/ReceivingTicket.xsd"}, :carrier=>"truck", :added_to_inventory_date=>{:@xmlns=>"http://rex11.com/swpublicapi/ReceivingTicket.xsd"}, :arrived_date=>{:@xmlns=>"http://rex11.com/swpublicapi/ReceivingTicket.xsd"}})
      end

      context 'return request item does not exist in WMS queue' do
        let(:item_return) { build(:item_return, bergen_asn_number: 'I-DO-NOT-EXIST') }

        it 'returns nil object' do
          expect(soap_method.result).to be_nil
        end
      end
    end
  end
end
