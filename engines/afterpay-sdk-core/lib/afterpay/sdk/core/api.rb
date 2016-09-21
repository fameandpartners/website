require 'base64'
require 'net/https'
require 'uri'
require 'cgi'
require 'faraday'

module Afterpay::SDK::Core
  class API
    attr_accessor :http, :uri, :service_name

    include Configuration
    include Exceptions
    include Logging

    DEFAULT_HTTP_HEADER = {
      'Content-Type' => 'application/json'
    }.freeze

    DEFAULT_END_POINTS = {
      live:    'https://api.secure-afterpay.com.au/v1',
      sandbox: 'https://api-sandbox.secure-afterpay.com.au/v1'
    }.freeze

    DEFAULT_API_MODE = :sandbox.freeze
    API_MODES        = DEFAULT_END_POINTS.keys.freeze

    DEFAULT_TIMEOUTS = {
      open: 10,
      read: 20
    }.freeze

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
      @uri ||= URI.parse(url_join(service_endpoint, service_name))
    end

    def create_http_connection(connection_uri = uri)
      Faraday.new(connection_uri) do |connection|
        connection.basic_auth(config.username, config.password)
        connection.adapter Faraday.default_adapter
      end
    end

    def http
      @http ||= create_http_connection
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

    def http_call(payload)
      if config.verbose_logging
        logger.info payload.inspect
      end

      response =
        log_http_call(payload) do
          http = payload[:http] || create_http_connection(payload[:uri])

          http.send(payload[:method]) do |req|
            req.url payload[:uri].request_uri
            req.headers = req.headers.merge(payload[:header])
            if payload[:method] == :post
              req.body = payload[:body]
            end

            req.options.timeout = DEFAULT_TIMEOUTS[:read]
            req.options.open_timeout = DEFAULT_TIMEOUTS[:open]
          end

        end

      if config.verbose_logging
        if response.status.to_i == 200
          logger.info(response.body)
        else
          logger.warn(response.body)
        end
      end

      handle_response(response)
    end

    def log_http_call(payload)
      logger.info "Request[#{payload[:method]}]: #{payload[:uri]}"
      start_time = Time.now
      response = yield
      logger.info sprintf("Response[%s]: %s, Duration: %.3fs", response.status,
        response_message(response), Time.now - start_time)
      response
    end

    def request(action, type, params = {}, header = {}, query = nil)
      action, params, header = "", action, params if action.is_a?(Hash)
      api_call(method: type, action: action, params: params, header: header)
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

    def handle_response(response)
      case response.status.to_i
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
        raise(ConnectionError.new(response, "Unknown response code: #{response.status}"))
      end
    end

    def format_request(payload)
      payload[:uri].path = url_join(payload[:uri].path, payload[:action])
      payload[:body]     = JSON.dump(payload[:params])
      payload[:header]   = payload[:header].merge(DEFAULT_HTTP_HEADER)
      payload
    end

    def format_response(payload)
      response = payload[:response]
      code = response.status.to_i
      payload[:data] =
        if code >= 200 && code <= 299
          response.body ? JSON.load(response.body) : {}
        elsif response.content_type == 'application/json'
          { 'error' => JSON.load(response.body) }
        else
          { 'error' => { 'name' => response.status, 'message' => response_message(response),
            'developer_msg' => response } }
        end
      payload
    end

    def response_message(res)
      response_object = JSON.load(res.body)
      if response_object.is_a?(Hash)
        response_object.fetch('message', '')
      end
    end

    def url_join(path, action)
      uri_path = [path, action].join('/')
      uri_path.gsub(/([^:])\/\//, '\1/')
    end

    def format_error(exception, message)
      raise exception
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
