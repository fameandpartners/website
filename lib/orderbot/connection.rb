module Orderbot
  class Connection
    def initialize
      @username =  ENV['ORDERBOT_USERNAME']
      @password = ENV['ORDERBOT_PASSWORD']
      @base_url = "http://api.orderbot.com/admin/"
    end

    def post( url, params )
      
    end

    def get( url, parameters = {})
      uri = @base_url + url
      response = begin
                   RestClient::Request.execute method: :get, url: uri, user: @username, password: @password
                 rescue RestClient::Exception => e
                   puts e
                   throw e
                 end
      response
    end
    
  end
end



