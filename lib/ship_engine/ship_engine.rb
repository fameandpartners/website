require "uri"
require "net/http"
require 'openssl'
require 'json'
module ShipEngine
  class ShippingLabel
    attr_accessor :label_url,
                  :carrier,
                  :label_image_url,
                  :label_pdf_url,
                  :barcode

    def initialize(first_name, last_name, address, email, return_id,phone,order_id)
      puts "SSSSSSSSSSSSSSSSSS-------ShippingLabel:initialize----------------SSSSSSSSSSSSSSSSSS"
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
      @phone = phone
      @order_id = order_id
      puts first_name
      puts last_name
      puts email
      puts address.address1
      puts address.address2
      puts address.city
      puts address.state&.abbr
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
      puts "SSSSSSSS-------fetch_shipping_label_from_api--------SSSSSSSS"
      url = URI(ENV['SHIPENGINE_API'])
      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = ENV['SHIPENGINE_USE_SSL'] == 'true'

      request = Net::HTTP::Post.new(url)
      request["Host"] = ENV['SHIPENGINE_HOST']
      request["API-Key"] = ENV['SHIPENGINE_KEY']
      request["Content-Type"] = "application/json"
      # request.body = "{\n  \"shipment\": {\n    \"service_code\": \"usps_priority_mail\",\n    \"ship_to\": {\n      \"name\": \"Jane Doe\",\n      \"address_line1\": \"525 S Winchester Blvd\",\n      \"city_locality\": \"San Jose\",\n      \"state_province\": \"CA\",\n      \"postal_code\": \"95128\",\n      \"country_code\": \"US\",\n      \"address_residential_indicator\": \"yes\"\n    },\n    \"ship_from\": {\n      \"name\": \"John Doe\",\n      \"company_name\": \"Example Corp\",\n      \"phone\": \"555-555-5555\",\n      \"address_line1\": \"4009 Marathon Blvd\",\n      \"city_locality\": \"Austin\",\n      \"state_province\": \"TX\",\n      \"postal_code\": \"78756\",\n      \"country_code\": \"US\",\n      \"address_residential_indicator\": \"no\"\n    },\n    \"packages\": [\n      {\n        \"weight\": {\n          \"value\": 20,\n          \"unit\": \"ounce\"\n        },\n        \"dimensions\": {\n          \"height\": 6,\n          \"width\": 12,\n          \"length\": 24,\n          \"unit\": \"inch\"\n        }\n      }\n    ]\n  }\n}"
      request.body = make_request_map.to_json
      puts "SSSSSSSSSSSSSSSSSSSSSSS request.body  SSSSSSSSSSSSSSSSSSSSSSSSSS"
      puts make_request_map.to_json
      response = https.request(request)
      if(response.kind_of? Net::HTTPSuccess)
        puts "SSSSSSSS-------fetch_shipping_label_from_api HTTPSuccess --------SSSSSSSS"
        convert_json_to_instance_variables(JSON.parse(response.read_body))
      else
        puts "SSSSSSSS-------fetch_shipping_label_from_api nil --------SSSSSSSS"
        puts JSON.parse(response.read_body)
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
                "value"=> 32.00
              },
              "label_messages"=>@return_id,
            }
          ],
          "carrier_id"=> "se-243802",
          "service_code"=>"usps_priority_mail",
          "ship_to"=>{
            "address_line1"=>"16012 Arthur St",
            "address_residential_indicator"=> "no",
            "city_locality"=>"Cerritos",
            "company_name"=> "Fame and Partners – Returns",
            "country_code"=> "US",
            "postal_code"=>"78756",
            "state_province"=> "CA"
          },
          "ship_from"=> {
            "address_line1"=>@address_1,
            "address_residential_indicator"=> "yes",
            "city_locality"=> @city,
            "country_code"=> @country,
            "name"=> full_name,
            "postal_code"=>@zip,
            "state_province"=> @state,
            "phone"=>@phone.to_s
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
      puts "SSSSSSSS-------convert_json_to_instance_variables HTTPSuccess --------SSSSSSSS"
      puts json.to_hash
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
