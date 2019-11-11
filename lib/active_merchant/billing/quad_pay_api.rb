require 'net/http'
require 'uri'
require 'json'
require 'rest-client'
module ActiveMerchant
  module Billing
    class QuadPayApi
      attr_accessor :client_id, :client_secret, :test_mode

      def initialize(client_id, client_secret)
        @client_id = client_id
        @client_secret = client_secret

      end

      def auth_end_point
        @auth_end_point ||=
          ENV['QP_TOKEN_URL']
      end

      def auth_audience
        @auth_audience ||=
          # 'https://auth-dev.quadpay.com'
          ENV['QP_AUDIENCE_URL']
      end

      def base_url
        @base_url ||=
          ENV['QP_API_URL']
      end

      def send_request_get(path = '', body = {})
        access_token
        base_url_str = "#{base_url}/#{path}"
        #uri = URI.parse("#{base_url}/#{path}")
        begin
        response = RestClient.get(base_url_str, :content_type => "application/json", :accept => :json, :authorization => "Bearer #{@access_token}")
        rescue RestClient::ExceptionWithResponse => e
          Raven.capture_exception(e, extra: { url: base_url_str, body: body })
          response = nil
        end
        if !response.nil?
          JSON.parse(response)
        else
          nil
        end
      end

      def send_request_post( path = '', body = {})
        access_token
        base_url_str = "#{base_url}/#{path}"
        #uri = URI.parse("#{base_url}/#{path}")
        begin
          response = RestClient.post(base_url_str, body.to_json, :content_type => "application/json", :accept => :json, :authorization => "Bearer #{@access_token}")
        rescue RestClient::ExceptionWithResponse => e
          Raven.capture_exception(e, extra: { url: base_url_str, body: body })
          response = nil
        end
        if !response.nil?
          JSON.parse(response)
        else
          nil
        end
      end

      def access_token
        return @access_token if @access_token.present?

        # uri = URI.parse(auth_end_point)
        # request = Net::HTTP::Post.new(uri)
        # request.basic_auth(@client_id, @client_secret)
        # request['content-type'] = 'application/json'
        #
        # request.set_form_data(
        #   'audience' => auth_audience,
        #   'grant_type' => 'client_credentials',
        #   'client_id' => @client_id,
        #   'client_secret' => @client_secret
        # )

        # response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        #   http.request(request)
        # end
        response = make_post_request(auth_end_point, {
          grant_type: 'client_credentials',
          client_id: @client_id,
          client_secret: @client_secret,
          audience: auth_audience,
        })

        unless response.nil?
          json_obj = JSON.parse(response)

          @access_token_expires_at = Time.now + json_obj['expires_in']
          @access_token = json_obj['access_token']
        end
        @access_token = JSON.parse(response.body)['access_token']
      end

      def make_post_request(url, body)
        begin
          return RestClient.post(url, body.to_json, :content_type => "application/json", :accept => :json)
        rescue RestClient::ExceptionWithResponse => e
          Raven.capture_exception(e, extra: { url: url, body: body })
        end
      end

      def make_get_request(url,body)
        begin
          return RestClient.get url, params: body.to_json, :accept => :json
        rescue RestClient::ExceptionWithResponse => e
          Raven.capture_exception(e, extra: { url: url, body: body })
        end
      end
    end
  end
end
