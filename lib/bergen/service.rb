# Note that this uses the Savon 1.2 API.

module Bergen
  class Service

    AVAILABLE_WSDLS = {
      production: 'https://sync.rex11.com/ws/v3prod/publicapiws.asmx?WSDL',
      staging:    'http://sync.rex11.com/ws/v2staging/publicapiws.asmx?WSDL',
    }.freeze

    attr_reader :credentials

    def initialize(credentials = default_credentials)
      @credentials = credentials
    end

    def get_inventory
      client.request :get_inventory do
        soap.body = { 'AuthenticationString' => auth_token }
      end
    end

    def receiving_ticket_add(return_request_item)
      ReceivingTicketAdd.new(
        savon_client:        client,
        auth_token:          auth_token,
        return_request_item: return_request_item
      ).request
    end

    def get_receiving_ticket_object_by_ticket_no
      # TODO
    end

    def style_master_product_add(return_request_item)
      StyleMasterProductAdd.new(
        savon_client:        client,
        auth_token:          auth_token,
        return_request_item: return_request_item
      ).request
    end

    def get_style_master_product_add_status(return_request_item)
      GetStyleMasterProductAddStatus.new(
        savon_client:        client,
        auth_token:          auth_token,
        return_request_item: return_request_item
      ).request
    end

    private

    def auth_token
      @auth_token ||= authenticate
    end

    def authenticate
      response = client.request :authentication_token_get do
        soap.body = {
          'WebAddress' => credentials.account_id,
          'UserName'   => credentials.username,
          'Password'   => credentials.password
        }
      end

      @auth_token = response[:authentication_token_get_response][:authentication_token_get_result]
    end

    def client
      @client ||= Savon.client(wsdl_file)
    end

    def wsdl_file
      AVAILABLE_WSDLS.fetch(Rails.env, AVAILABLE_WSDLS[:staging])
    end

    def default_credentials
      Credentials.fetch_default
    end
  end

  Credentials = Struct.new(:account_id, :username, :password) do
    def self.fetch_default
      new(config.account_id,
          config.username,
          config.password)
    end

    def self.config
      configatron.bergen
    end
  end
end
