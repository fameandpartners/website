require 'base64'
require 'net/https'
require 'uri'
require 'cgi'

module Afterpay::SDK::Core
  class API
    attr_accessor :http, :uri, :service_name

    include Configuration

    DEFAULT_HTTP_HEADER = {
      'Content-Type' => 'application/json'
    }.freeze

    DEFAULT_END_POINTS = {
      live: 'https://api.secure-afterpay.com.au',
      sandbox: 'https://api-sandbox.secure-afterpay.com.au/v1/'
    }.freeze

    DEFAULT_API_MODE = :sandbox.freeze
    API_MODES        = DEFAULT_END_POINTS.keys.freeze

    def initialize(service_name = '', environment = nil, options = {})
      unless service_name.is_a? String
        environment, options, service_name = service_name, environment || {}, ''
      end
      @service_name = service_name
      set_config(environment, options)
    end

    def service_endpoint
      config.endpoint || DEFAULT_END_POINTS[api_mode]
    end

    def uri
      @uri ||=
        begin
          uri = URI.parse("#{service_endpoint}/#{service_name}")
          uri.path = uri.path.gsub(/\/+/, "/")
          uri
        end
    end

    def create_http_connection
      Net::HTTP.new(uri.host, uri.port)
    end

    def http
      @http ||= create_http_connection(uri)
    end

    def set_config(*args)
      @http = @uri = nil
    end

    def api_mode
      if config.mode && API_MODES.include?(config.mode.to_sym)
        config.mode.to_sym
      else
        DEFAULT_API_MODE
      end
    end

    def default_http_header
      { 'User-Agent' => self.class.user_agent }
    end

    def api_call(payload)
      payload[:header] = default_http_header.merge(payload[:header])
      payload[:uri]   ||= uri.dup
      payload[:http]  ||= http.dup
      payload[:uri].query = encode_www_form(payload[:query]) if payload[:query] and payload[:query].any?
      format_request(payload)
      payload[:response] = http_call(payload)
      format_response(payload)
      payload[:data]
    end

    def request(action, type, params = {}, header = {}, query = nil)
      action, params, header = "", action, params if action.is_a? Hash
      api_call(:method => :post, :action => action, :params => params, :header => header)
    end

    def post(action, params = {}, header = {})
      request(action, :post, params, header)
    end

    def get(action, params = {}, header = {})
      request(action, :get, nil, header, params)
    end

    def patch(action, params = {}, header = {})
      request(action, :patch, params, header)
    end

    def put(action, params = {}, header = {})
      request(action, :put, params, header)
    end

    def delete(action, params = {}, header = {})
      request(action, :delete, params, header)
    end

    def format_request(payload)
      payload[:uri].path = url_join(payload[:uri].path, payload[:action])
      payload[:body] = payload[:params].to_s
      payload
    end

    def format_response(payload)
      payload[:data] = payload[:response].body
      payload
    end

    def format_error(exception, message)
      raise exception
    end

    def token
      Base64.urlsafe_encode64("#{config.username}:#{config.password}")
    end

    # Get access token type
    def token_type
      'Bearer'
    end

    def handle_response(response)
      case response.code.to_i
      when 301, 302, 303, 307
        raise(Redirection.new(response))
      when 200...400
        response
      when 400
        # raise(BadRequest.new(response))
        error.response
      when 401
        raise(UnauthorizedAccess.new(response))
      when 403
        raise(ForbiddenAccess.new(response))
      when 404
        raise(ResourceNotFound.new(response))
      when 405
        raise(MethodNotAllowed.new(response))
      when 409
        raise(ResourceConflict.new(response))
      when 410
        raise(ResourceGone.new(response))
      when 422
        raise(ResourceInvalid.new(response))
      when 401...500
        raise(ClientError.new(response))
      when 500...600
        raise(ServerError.new(response))
      else
        raise(ConnectionError.new(response, "Unknown response code: #{response.code}"))
      end
    end

    def format_request(payload)
      payload[:uri].path = url_join(payload[:uri].path, payload[:action])
      payload[:header] =
        { 'Authorization' => "#{token_type} #{token}"}
          .merge(DEFAULT_HTTP_HEADER)

      payload[:body] = MultiJson.dump(payload[:params])
      payload
    end

    def format_response(payload)
      response = payload[:response]
      payload[:data] =
        if response.code >= '200' && response.code <= '299'
          response.body && response.content_type == 'application/json' ? MultiJson.load(response.body) : {}
        elsif response.content_type == 'application/json'
          { 'error' => MultiJson.load(response.body) }
        else
          { 'error' => { 'name' => response.code, 'message' => response.message,
            'developer_msg' => response } }
        end
      payload
    end

    # Log Afterpay-Request-Id header
    def log_http_call(payload)
      if payload[:header] && payload[:header]['Afterpay-Request-Id']
        logger.info "Afterpay-Request-Id: #{payload[:header]['Afterpay-Request-Id']}"
      end
    end

    class << self
      def sdk_library_details
        @library_details ||= "afterpay-sdk-core #{VERSION}; ruby #{RUBY_VERSION}p#{RUBY_PATCHLEVEL}-#{RUBY_PLATFORM}"
      end

      def user_agent
        @user_agent ||= "AfterpaySDK/sdk-core-ruby #{VERSION} (#{sdk_library_details})"
      end
    end

  end
end
