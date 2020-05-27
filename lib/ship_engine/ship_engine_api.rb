require "uri"
require "net/http"
require 'openssl'
require 'json'
module ShipEngine
  class ShippingLabelAPI
    def tracking_package( lable_id)
      puts "SSSSSSSS-------fetch_shipping_label_from_api--------SSSSSSSS"
      puts "https://api.shipengine.com/v1/labels/se-#{lable_id.to_s}/track"
      url = URI("https://api.shipengine.com/v1/labels/se-#{lable_id.to_s}/track")
      https = Net::HTTP.new(url.host, url.port);
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["Host"] = ENV['SHIPENGINE_HOST']
      request["API-Key"] = ENV['SHIPENGINE_KEY']
      # request["API-Key"] = "TEST_iAeivt9YIpMFRwHOcyMWmkIghcRPqHuZSnZYn1NRgRA"
      request["Cache-Control"] = "no-cache"
      response = https.request(request)
      puts response.read_body
      response
    end
  end
end

