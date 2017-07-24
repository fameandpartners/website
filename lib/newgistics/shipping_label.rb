module Newgistics
  class ShippingLabel
    def initialize(first_name, last_name, email, return_id)
      @first_name = first_name
      @last_name = last_name
      @email = email
      @return_id = return_id

      fetch_shipping_label_from_api()
    end

    private

    def fetch_shipping_label_from_api
      uri = URI('https://apiint.newgistics.com/WebAPI/Shipment/')
      request = Net::HTTP::Post.new(
        uri,
        'Content-Type' => 'application/json',
        'x-api-key' => configatron.newgistics.api_key
      )

      request.body = make_request_map.to_json
      puts request.body
      puts 'starting request'
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end
      puts 'completed request'
      binding.pry

      json_response = JSON.parse(response.body)
    end

    def make_address_map
      {
        "Address" => {
          "Address1" => configatron.newgistics.return_street_0,
          "Address2" => "",
          "Address3" => "",
          "City" => configatron.newgistics.return_city,
          "CountryCode" => "US",
          "State" => configatron.newgistics.return_state,
          "Zip" => configatron.newgistics.return_zip
        }
      }
    end

    def make_request_map
      {
        "clientServiceFlag" => "Standard",
        "consumer" => {
          "FirstName" => @first_name,
          "LastName" => @last_name,
          "PrimaryEmailAddress" => @email
        }.merge(make_address_map),
        "deliveryMethod" => "SelfService",
        "dispositionRuleSetId" => configatron.newgistics.disposition_rule_set,
        "labelCount" => 1,
        "merchantID" => configatron.newgistics.merchant_id
      }.merge(make_return_id_map)
    end

    def make_return_id_map
      if using_newgistics_staging_env?
        {"returnId" => "123456789A"}
      else
        {"returnId" => @return_id}
      end
    end

    def using_newgistics_staging_env?
      Rails.env != 'production'
    end
  end
end
