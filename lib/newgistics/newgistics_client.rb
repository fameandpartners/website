require 'rest_client'
module Newgistics
  class NewgisticsClient

    def initialize(api_key)
      @key = api_key
    end

    def get_inbound_returns(start_date, end_date)
      params= { :key=>@key, :startCreatedTimestamp => start_date.to_s, :endCreatedTimestamp => end_date.to_s  }
      response = make_get_request("#{configatron.newgistics.returns_uri.to_s}/inbound_returns.aspx", params)
      Hash.from_xml(response)
    end

    def make_get_request(url, params)
      RestClient.get("#{url}/?#{params.to_query}", :content_type => "text/xml")
    end

  end
end
