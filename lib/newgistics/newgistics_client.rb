# frozen_string_literal: true

require 'rest_client'
require 'net/http'
require 'http'
module Newgistics
  class NewgisticsClient
    def initialize
      @key = configatron.newgistics.returns_api_key
    end

    def get_returns(start_date, end_date)
      params = { key: @key, startTimestamp: start_date.to_s, endTimestamp: end_date.to_s }
      #puts params
      puts params.to_query
      response = make_get_request("#{configatron.newgistics.returns_uri}/returns.aspx", params)
      Hash.from_xml(response)
    end

    def get_inventory_details(start_date)
      params = { key: @key, startTimestamp: start_date.to_s }
      response = make_get_request("#{configatron.newgistics.returns_uri}/inventory_details.aspx", params)
      Hash.from_xml(response)
    end

    def get_shipped_returns(start_date, end_date)
      params = { key: @key, startShippedTimestamp: start_date.to_s, endShippedTimestamp: end_date.to_s }
      response = make_get_request("#{configatron.newgistics.returns_uri}/shipments.aspx", params)
      Hash.from_xml(response)
    end

    def make_get_request(url, params)
      #RestClient.get("https://api.newgisticsfulfillment.com/returns.aspx?key=fff5c2b8cccc470ab7e80258a3b0e07e&startTimestamp=2019-02-28T08:00:00&endTimestamp=2019-03-01T07:00:00", content_type: 'text/xml')
      #RestClient.get("https://cn.bing.com", content_type: 'text/xml')
      #uri = URI("https://api.newgisticsfulfillment.com/returns.aspx?key=fff5c2b8cccc470ab7e80258a3b0e07e&startTimestamp=2019-02-28T08:00:00&endTimestamp=2019-03-01T07:00:00")
      #puts Net::HTTP.get(uri)
      url = "https://api.newgisticsfulfillment.com/returns.aspx?key=fff5c2b8cccc470ab7e80258a3b0e07e&startTimestamp=2019-02-28T08:00:00&endTimestamp=2019-03-01T07:00:00"
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
      puts HTTP.headers(:content_type => "text/xml").get(url, :ssl_context => ctx).to_s
      HTTP.headers(:content_type => "text/xml").get(url, :ssl_context => ctx).to_s
      end
  end
end
