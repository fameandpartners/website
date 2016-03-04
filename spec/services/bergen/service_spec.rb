require 'spec_helper'


module Bergen
  RSpec.describe Service do

    describe 'calling test API' do
      let(:service) { described_class.new }
    end

    context 'Bergen API versions' do
      let(:service) { described_class.new }

      let(:known_version3_methods) {
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
          :get_pick_tickets_by_order_number,
          :get_pick_tickes_by_status_and_create_date,
          :get_pick_ticket_object_items_in_boxes,
          :get_pick_ticket_object_items_in_boxes_v2,
          :get_pick_ticket_statuses_by_date,
          :get_pick_ticket_statuses_by_ship_date,
          :style_master_product_add,
          :style_master_product_update_by_upc,
          :get_style_master_product_add_status
        ]
      }

      let(:known_version2_methods) {
        known_version3_methods - [:get_pick_tickets_by_order_number, :style_master_product_update_by_upc]
      }

      describe 'version 2 - staging' do
        it 'correctly loads wsdl methods' do
          expect(service.client.wsdl.soap_actions).to eq known_version2_methods
        end

        it 'finds the staging endpoint' do
          expect(service.client.wsdl.endpoint).to eq(
            URI.parse('http://sync.rex11.com/ws/v2staging/publicapiws.asmx')
          )
        end

      end

      describe 'version 3 - production' do
        before do
          def service.environment
            :production
          end
        end

        it 'correctly loads wsdl methods' do
          expect(service.client.wsdl.soap_actions).to eq known_version3_methods
        end

        it 'finds the production endpoint' do
          expect(service.client.wsdl.endpoint).to eq(
            URI.parse('https://sync.rex11.com/ws/v3prod/publicapiws.asmx')
          )
        end
      end
    end
  end
end
