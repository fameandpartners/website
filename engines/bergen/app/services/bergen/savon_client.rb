# Note that this uses the Savon 1.2 API.

module Bergen
  class SavonClient
    extend Forwardable

    AVAILABLE_WSDLS = {
      'production' => 'https://sync.rex11.com/ws/v3prod/publicapiws.asmx?WSDL',
      'staging'    => 'https://sync.rex11.com/ws/v3staging/publicapiws.asmx?WSDL',
    }.freeze

    attr_reader :client
    def_delegators :client, :request, :wsdl

    def initialize
      @client ||= Savon.client(wsdl_file)
    end

    def auth_token
      @auth_token ||= authenticate
    end

    private

    def authenticate
      response = client.request :authentication_token_get do
        soap.body = {
          'WebAddress' => default_credentials.account_id,
          'UserName'   => default_credentials.username,
          'Password'   => default_credentials.password
        }
      end

      response[:authentication_token_get_response][:authentication_token_get_result]
    end

    def wsdl_file
      AVAILABLE_WSDLS.fetch(Rails.env, AVAILABLE_WSDLS['staging'])
    end

    def default_credentials
      Credentials.fetch_default
    end

    Credentials = Struct.new(:account_id, :username, :password) do
      def self.fetch_default
        new(
          config[:account_id],
          config[:username],
          config[:password]
        )
      end

      def self.config
        {
          account_id: ENV['BERGEN_ACCOUNT_ID'],
          username:   ENV['BERGEN_USERNAME'],
          password:   ENV['BERGEN_PASSWORD']
        }
      end
    end
  end
end
