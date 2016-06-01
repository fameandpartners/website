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

      # Temporary solution while we don't follow 12 factor 100%
      def self.config
        if Rails.env.production?
          {
            account_id: ENV.fetch('BERGEN_ACCOUNT_ID', 'www.fame&partnersinc.com'),
            username:   ENV.fetch('BERGEN_USERNAME', 'fameandpartners'),
            password:   ENV.fetch('BERGEN_PASSWORD', 'pr0jectpr0m')
          }
        else
          {
            account_id: ENV.fetch('BERGEN_ACCOUNT_ID', 'www.fame&partnersinc.com'),
            username:   ENV.fetch('BERGEN_USERNAME', 'fameandpartners'),
            password:   ENV.fetch('BERGEN_PASSWORD', 'not_set')
          }
        end
      end
    end
  end
end
