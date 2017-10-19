# frozen_string_literal: true

require 'rest_client'
module Newgistics
  class NewgisticsClient
    def initialize
      @key = configatron.newgistics.returns_api_key
    end

    def get_returns(start_date, end_date)
      params = { key: @key, startTimestamp: start_date.to_s, endTimestamp: end_date.to_s }
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
      RestClient.get("#{url}/?#{params.to_query}", content_type: 'text/xml')
    end
  end
end
