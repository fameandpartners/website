require 'spec_helper'

module Bergen
  RSpec.describe SavonClient, vcr: true do
    let(:client) { described_class.new }

    context 'Bergen API versions' do
      let(:savon_client) { client.client }
      let(:known_staging_methods) {
        [
          :authentication_token_get,
          :get_inventory,
          :get_inventory_by_batch,
          :get_inventory_from_date_time,
          :get_inventory_from_date_time_by_batch,
          :get_inventory_by_up_cs,
          :get_inventory_by_style,
          :get_receiving_statuses_by_date,
          :get_receiving_statuses_by_date_configurable,
          :get_receiving_tickets_by_po,
          :get_receiving_ticket_object_by_ticket_no,
          :get_receiving_tickets_by_status_and_create_date,
          :receiving_ticket_add,
          :get_receiving_ticket_add_status,
          :pick_ticket_add,
          :get_pick_ticket_add_status,
          :cancel_pick_ticket,
          :get_pick_ticket_object_by_bar_code,
          :get_pick_tickes_by_status_and_create_date,
          :get_pick_ticket_object_items_in_boxes,
          :get_pick_ticket_object_items_in_boxes_v2,
          :get_pick_ticket_statuses_by_date,
          :get_pick_ticket_statuses_by_ship_date,
          :style_master_product_add,
          :get_style_master_product_add_status
        ]
      }

      describe 'staging' do
        it 'correctly loads wsdl methods' do
          expect(savon_client.wsdl.soap_actions).to match_array(known_staging_methods)
        end

        it 'finds the staging endpoint' do
          uri_endpoint = URI.parse('http://sync.rex11.com/ws/v2staging/publicapiws.asmx')
          expect(savon_client.wsdl.endpoint).to eq(uri_endpoint)
        end

      end

      describe 'production' do
        let(:known_production_methods) { known_staging_methods + [:get_pick_tickets_by_order_number, :style_master_product_update_by_upc] }

        before(:each) do
          allow(Rails).to receive(:env).and_return(:production)
        end

        it 'correctly loads wsdl methods' do
          expect(savon_client.wsdl.soap_actions).to match_array(known_production_methods)
        end

        it 'finds the production endpoint' do
          uri_endpoint = URI.parse('https://sync.rex11.com/ws/v3prod/publicapiws.asmx')
          expect(savon_client.wsdl.endpoint).to eq(uri_endpoint)
        end
      end
    end

    describe '#auth_token' do
      it do
        result = client.auth_token
        expect(result).to eq('ikHA4ffH3PL4JqFksqzIyexF980zGgPNTEW0MaOTNnfWUpJ+Yb6Cnw==')
      end
    end
  end
end
