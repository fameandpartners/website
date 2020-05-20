require 'json'
module ShipEngine
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
      # uri = URI( ENV['SHIPENGINE_HOST'])
      # request = Net::HTTP::Post.new(
      #   uri,
      #   {
      #     'Accept' => 'application/json',
      #     'Content-Type' => 'application/json',
      #     'x-api-key' => ENV['SHIPENGINE_RETUREN_API_KEY']
      #   }
      # )
      # request.body = make_request_map.to_json
      #
      # http = Net::HTTP.new(uri.host, uri.port)
      # http.use_ssl = (uri.scheme == "https")
      # response = http.request(request)
      # if(response.kind_of? Net::HTTPSuccess)
      #   convert_json_to_instance_variables(JSON.parse(response.body))
      # else
      #   nil
      # end

      url = URI("http://api.shipengine.com/v1/labels")
      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = false

      request = Net::HTTP::Post.new(url)
      request["Host"] = "api.shipengine.com"
      request["API-Key"] = "lSapg0JYROO4iUnGb4OKBKs0ehKQkzD4whGO1+GZRaA"
      request["Content-Type"] = "application/json"
      request.body = make_request_map.to_json
      response = https.request(request)
      if(response.kind_of? Net::HTTPSuccess)
        convert_json_to_instance_variables(JSON.parse(response.read_body))
      else
        nil
      end
    end
    private

    def make_address_map
      # {
      #   "Address" => {
      #     "Address1" => @address_1,
      #     "Address2" => @address_2,
      #     "Address3" => "",
      #     "City" => @city,
      #     "CountryCode" => @country,
      #     "State" => @state,
      #     "Zip" => @zip
      #   }
      # }
    end

    def make_request_map
      # newgistics_conf = get_facitily_by_location(@address)
      # {
      #   "clientServiceFlag" => "Standard",
      #   "consumer" => {
      #     "FirstName" => @first_name,
      #     "LastName" => @last_name,
      #     "PrimaryEmailAddress" => @email
      #   }.merge(make_address_map),
      #   "deliveryMethod" => "SelfService",
      #   "dispositionRuleSetId" => newgistics_conf['rule_set'],
      #   "labelCount" => 1,
      #   "merchantID" => newgistics_conf['merchant_id']
      # }.merge(make_return_id_map)
      full_name = @first_name + ' ' +  @last_name
      {
        "shipment" =>{
          "packages"=> [
            {
              "dimensions"=> {
                "height"=>1.97,
                "length"=>13.8,
                "unit"=>"inch",
                "width"=> 10.23
              },
              "weight"=>{
                "unit"=>"ounce",
                "value"=> 4.41
              }
            }
          ],
          "service_code"=>"ups_ground",
          "ship_to"=>{
            "address_line1"=>"4009 Marathon Blvd",
            "address_residential_indicator"=> "no",
            "city_locality"=>"Austin",
            "company_name"=> "Example Corp",
            "country_code"=> "US",
            "name"=>"John Doe",
            "phone"=> "555-555-5555",
            "postal_code"=>"78756",
            "state_province"=> "TX"
          },
          "ship_from"=> {
            "address_line1"=>@address_1,
            "address_residential_indicator"=> "yes",
            "city_locality"=> @city,
            "country_code"=> @country,
            "name"=> full_name,
            "postal_code"=>address.zipcode,
            "state_province"=> @state
          }
        }
      }
    end

    def make_return_id_map
      if Rails.env == 'production'
        {"returnId" => @return_id}
      else
        {"returnId" => @return_id}
      end
    end

    def convert_json_to_instance_variables(json)
      lable_hash = json.to_hash
      if lable_hash.has_key?("label_download")
        @label_url = lable_hash["label_download"]["pdf"]
        @label_image_url = lable_hash["label_download"]["png"]
        @label_pdf_url = lable_hash["label_download"]['href']
      end
      if lable_hash.has_key?("carrier_code")
        @carrier = lable_hash["carrier_code"]
        @barcode = lable_hash["carrier_code"]
      end
    end
  end
end
