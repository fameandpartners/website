# IMPORTANT NOTE: ReceivingTicketAdd WMS methods does not respect their WSDL format at all! Do NOT try to use Savon's
# Default namespacing, otherwise you'll only get errors.
# For this motive, its payload needs to be manually prepared (building the XML and "namespaces" from scratch)

module Bergen
  module SoapMethods
    class ReceivingTicketAdd < BaseRequest
      DEFAULT_SOAP_NAMESPACES = {
        'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/',
        'xmlns:xsd'  => 'http://www.w3.org/2001/XMLSchema',
        'xmlns:xsi'  => 'http://www.w3.org/2001/XMLSchema-instance',
      }.freeze
      WMS_NAMESPACES          = {
        custom_order:           { xmlns: 'http://rex11.com/swpublicapi/CustomerOrder.xsd' },
        receiving_ticket:       { xmlns: 'http://rex11.com/swpublicapi/ReceivingTicket.xsd' },
        receiving_ticket_items: { xmlns: 'http://rex11.com/swpublicapi/ReceivingTicketItems.xsd' },
        rex:                    { xmlns: 'http://rex11.com/webmethods/' },
      }.freeze


      attr_reader :client, :return_request_item

      def initialize(savon_client:, return_request_item:)
        @client              = savon_client
        @return_request_item = return_request_item
      end

      def response
        client.request :receiving_ticket_add do
          soap.xml { |xml_builder| prepare_xml(xml_builder) }
        end
      end

      def result
        { receiving_ticket_id: response[:receiving_ticket_add_response][:receiving_ticket_add_result][:receiving_ticket_id] }
      end

      private

      def prepare_xml(xml)
        xml.soap(:Envelope, DEFAULT_SOAP_NAMESPACES) do |envelope|
          envelope.soap(:Body) do |body|
            body.ReceivingTicketAdd(WMS_NAMESPACES[:rex]) do |ticket_add|
              ticket_add.AuthenticationString(client.auth_token)

              ticket_add.receivingTicket(WMS_NAMESPACES[:receiving_ticket]) do |receiving_ticket|
                receiving_ticket.ReceivingStatus('Draft') # Always start as a draft. Constant
                receiving_ticket.ReceivingStatusCode('0') # Always zero. Draft status code
                receiving_ticket.CreatedDate(Date.today.strftime('%m/%d/%Y')) # Format is mm/dd/yyyy

                receiving_ticket.Shipmentitemslist do |shipment|
                  shipment.Style(global_sku.style_number, WMS_NAMESPACES[:receiving_ticket_items])
                  shipment.Color(global_sku.color_name, WMS_NAMESPACES[:receiving_ticket_items])
                  shipment.UPC(global_sku.upc, WMS_NAMESPACES[:receiving_ticket_items])
                  shipment.Size(global_sku.size, WMS_NAMESPACES[:receiving_ticket_items])
                  shipment.ExpectedQuantity('1', WMS_NAMESPACES[:receiving_ticket_items]) # Required, but field is ignored
                  shipment.ActualQuantity('1', WMS_NAMESPACES[:receiving_ticket_items]) # Required, but field is ignored
                  shipment.DamagedQuantity('0', WMS_NAMESPACES[:receiving_ticket_items]) # Required, but field is ignored
                  # shipment.UnitCost('1', WMS_NAMESPACES[:receiving_ticket_items])
                  # shipment.ProductDescription('Shoes', WMS_NAMESPACES[:receiving_ticket_items])
                  shipment.ProductMSRP(line_item_presenter.price, WMS_NAMESPACES[:receiving_ticket_items])
                  # shipment.Comments('This is a test', WMS_NAMESPACES[:receiving_ticket_items])
                  shipment.ShipmentType('OPENTOHANG', WMS_NAMESPACES[:receiving_ticket_items])
                  # shipment.ReturnReasonCode('string', WMS_NAMESPACES[:receiving_ticket_items])
                end

                receiving_ticket.ShipmentTypelist('OPENTOHANG')
                receiving_ticket.Warehouse('BERGEN LOGISTICS WEST')
                # receiving_ticket.Memo('Memo')
                # receiving_ticket.AuthorizedNumber('Auth 123')
                # receiving_ticket.CustomerPO('PO 123')
                # receiving_ticket.LicensePlate('LP12')
                # receiving_ticket.DriverName('Tom')
                # receiving_ticket.TrackingNumbers('1Z23456')
                # receiving_ticket.ExpectedDate('02-16-2012')

                receiving_ticket.SupplierDetails do |supplier|
                  supplier.CompanyName('Fame & Partners', WMS_NAMESPACES[:custom_order])
                  # supplier.Address1('123 Main Street', WMS_NAMESPACES[:custom_order])
                  # supplier.Address2('', WMS_NAMESPACES[:custom_order])
                  # supplier.City('New York', WMS_NAMESPACES[:custom_order])
                  supplier.State('NY', WMS_NAMESPACES[:custom_order])
                  # supplier.Zip('10001', WMS_NAMESPACES[:custom_order])
                  supplier.Country('USA', WMS_NAMESPACES[:custom_order])
                  # supplier.Non_US_Region('', WMS_NAMESPACES[:custom_order])
                  # supplier.Phone('212-555-1212', WMS_NAMESPACES[:custom_order])
                  # supplier.Fax('212-555-1212', WMS_NAMESPACES[:custom_order])
                  # supplier.Email('', WMS_NAMESPACES[:custom_order])
                end

                receiving_ticket.Carrier('Truck')
              end
            end
          end
        end
      end

      def line_item_presenter
        return_request_item.line_item_presenter
      end

      def global_sku
        line_item_presenter.global_sku
      end
    end
  end
end
