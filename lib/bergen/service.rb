# Note that this uses the Savon 1.2 API.

module Bergen
  class Service

    AVAILABLE_WSDLS = {
      production: 'lib/bergen/wsdl/production.publicapiws.asmx.xml',
      staging:    'lib/bergen/wsdl/staging.publicapiws.asmx.xml',
    }

    attr_reader :credentials

    def initialize(credentials = default_credentials)
      @credentials = credentials
    end

    private def default_credentials
      Credentials.fetch_default
    end

    def auth_token
      @auth_token ||= authenticate
    end

    def authenticate
      # We require the string keys as they literally interpolated to the XML.
      authentication_hash = {
        'WebAddress!' => credentials.account_id,
        'UserName'    => credentials.username,
        'Password'    => credentials.password
      }

      response = client.request :authentication_token_get do
        soap.body = authentication_hash
      end

      @auth_token = response[:authentication_token_get_response][:authentication_token_get_result]
    end

    def auth_values
      { 'AuthenticationString' => auth_token }
    end

    def get_inventory
      client.request :get_inventory do
        soap.body = auth_values
      end
    end

    def authentication_xml
      %Q|<AuthenticationString xmlns="http://rex11.com/webmethods/">#{auth_token}</AuthenticationString>|
    end

    # def rta
    #   {
    #     'ReceivingTicket' => {
    #       'Shipmentitemslist' => {
    #         'Style'            => 'FPS1234',
    #         # 'SKU'                => O,
    #         'Color'            => 'RED',
    #         # 'UPC'              => O,
    #         'Size'             => 'US6AU10',
    #         'ExpectedQuantity' => 1,
    #         'ActualQuantity'   => 1,
    #         'DamagedQuantity'  => 0,
    #       },
    #       'ShipmentTypelist'  => "OPENTOHANG",
    #       'Warehouse'         => 'BERGEN LOGISTICS NJ',
    #       'SupplierDetails'   => {
    #         'CompanyName' => "FAMEPARTNERS",
    #         'State'       => 'NJ',
    #         'Country'     => 'United States'
    #       },
    #       'Carrier'           => 'FEDEX',
    #     }
    #   }
    # end

    def receiving_ticket_add(receiving_ticket)
      ffs = %Q|
      <AuthenticationString xmlns="http://rex11.com/webmethods/">#{auth_token}</AuthenticationString>
      <receivingTicket xmlns="http://rex11.com/swpublicapi/ReceivingTicket.xsd">
        <Shipmentitemslist>
          <Style xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">Fun</Style>
          <Color xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">Navy</Color>
          <Size xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">8.5</Size>
          <ExpectedQuantity xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">10</ExpectedQuantity>
          <UnitCost xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">1</UnitCost>
          <ProductDescription xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">Shoes</ProductDescription>
          <ProductMSRP xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">1</ProductMSRP>
          <Comments xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">This is a test</Comments>
          <ShipmentType xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">FLAT</ShipmentType>
        </Shipmentitemslist>
        <Shipmentitemslist>
          <Style xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">Open</Style>
          <Color xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">Red</Color>
          <Size xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">XL</Size>
          <ExpectedQuantity xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">12</ExpectedQuantity>
          <UnitCost xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">15</UnitCost>
          <ProductDescription xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">Dress</ProductDescription>
          <ProductMSRP xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">1</ProductMSRP>
          <Comments xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">Comments0</Comments>
          <ShipmentType xmlns="http://rex11.com/swpublicapi/ReceivingTicketItems.xsd">FLAT</ShipmentType>
        </Shipmentitemslist>
        <ShipmentTypelist>FLAT</ShipmentTypelist>
        <ShipmentTypelist>GOH</ShipmentTypelist>
        <Warehouse>BERGEN LOGISTICS NJ2</Warehouse>
        <Memo>Memo</Memo>
        <AuthorizedNumber>Auth 123</AuthorizedNumber>
        <CustomerPO>PO 123</CustomerPO>
        <LicensePlate>LP12</LicensePlate>
        <DriverName>Tom</DriverName>
        <TrackingNumbers>1Z23456</TrackingNumbers>
        <ExpectedDate>02-16-2012</ExpectedDate>
        <SupplierDetails>
          <CompanyName xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd">CompanyName</CompanyName>
          <Address1 xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd">123 Main Street</Address1>
          <Address2 xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd"></Address2>
          <City xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd">New York</City>
          <State xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd">NY</State>
          <Zip xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd">10001</Zip>
          <Country xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd">USA</Country>
          <Non_US_Region xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd"></Non_US_Region>
          <Phone xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd">212-555-1212</Phone>
          <Fax xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd">212-555-1212</Fax>
          <Email xmlns="http://rex11.com/swpublicapi/CustomerOrder.xsd"></Email>
        </SupplierDetails>
        <Carrier>Truck</Carrier>
      </receivingTicket>
      |

      ffs = authentication_xml + receiving_ticket.to_xml

      response = client.request :receiving_ticket_add do
        # soap.body = auth_values.merge(receiving_ticket)
        soap.body = ffs
      end
    end


    def client
      @client ||= Savon.client(wsdl_file.to_s)
    end

    def wsdl_file
      local_wsdl = AVAILABLE_WSDLS.fetch(environment, AVAILABLE_WSDLS[:staging])
      Rails.root.join(local_wsdl)
    end

    def environment
      Rails.env
    end
  end

  Credentials = Struct.new(:account_id, :username, :password) do
    def self.fetch_default
      new(config.account_id,
          config.username,
          config.password)
    end

    def self.config
      configatron.bergen
    end
  end
end
