module Bergen
  class ReceivingTicketAdd
    def self.from_item_return(item_return)
      # TODO - Finish
    end

    def to_xml
      ffs = %Q|
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
    end
  end
end
