include Newgistics::NewgisticsHelper

 module Newgistics
  class ShippingLabel
    attr_accessor :label_url,
                  :carrier,
                  :label_image_url,
                  :label_pdf_url,
                  :barcode

    def initialize(first_name, last_name, address, email, return_id)
      @first_name = first_name
      @last_name = last_name
      @email = email
      @address_1 = address.address1
      @address_2 = address.address2
      @city = address.city
      @state = address.state&.abbr
      @country = address.country.iso
      @zip = address.zipcode
      @return_id = return_id
      @address = address
    end

    def fetch_shipping_label_from_api
      uri = URI(configatron.newgistics.uri)
      request = Net::HTTP::Post.new(
        uri,
        {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'x-api-key' => configatron.newgistics.api_key
        }
      )
      request.body = make_request_map.to_json

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      response = http.request(request)
      if(response.kind_of? Net::HTTPSuccess)
        convert_json_to_instance_variables(JSON.parse(response.body))
      else
        nil
      end
    end

    private

    def make_address_map
      {
        "Address" => {
          "Address1" => @address_1,
          "Address2" => @address_2,
          "Address3" => "",
          "City" => @city,
          "CountryCode" => @country,
          "State" => @state,
          "Zip" => @zip
        }
      }
    end

    def make_request_map
      newgistics_conf = get_facitily_by_location(@address)
      {
        "clientServiceFlag" => "Standard",
        "consumer" => {
          "FirstName" => @first_name,
          "LastName" => @last_name,
          "PrimaryEmailAddress" => @email
        }.merge(make_address_map),
        "deliveryMethod" => "SelfService",
        "dispositionRuleSetId" => newgistics_conf['rule_set'],
        "labelCount" => 1,
        "merchantID" => newgistics_conf['merchant_id']
      }.merge(make_return_id_map).merge({"spreeOrderNumber": Spree::Order.find(@return_id).number})
    end

    def make_return_id_map
      { "returnId" => Spree::Order.find(@return_id).number }
    end

    def convert_json_to_instance_variables(json)
      @label_url = json['labelURL']
      @carrier = json['transporter']['Carrier']
      @barcode = json['transporter']['Barcode'] # is actually the tracking number

      json['links'].each do |link|
        if link['rel'] == 'label/image'
          @label_image_url = link['href']
        else
          @label_pdf_url = link['href']
        end
      end
    end
  end
end
