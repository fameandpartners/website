# Note that this uses the Savon 1.2 API.

module Bergen
  class Service

    AVAILABLE_WSDLS = {
      production: 'lib/bergen/wsdl/production.publicapiws.asmx.xml',
      staging:    'lib/bergen/wsdl/staging.publicapiws.asmx.xml',
    }

    attr_reader :credentials

    def initialize(credentials = default_credentials)
      @credentials = credentials
    end

    private def default_credentials
              Credentials.fetch
    end


    def authenticate
      # We require the strings as they literally interpolated to the XML.
      authentication_hash = {
        "WebAddress!" => credentials.account_id,
        "UserName"   => credentials.username,
        "Password"   => credentials.password
      }

      client.request :authentication_token_get do
        soap.body = authentication_hash
      end
    end

    def client
      @client ||= Savon.client(wsdl_file.to_s)
    end

    def wsdl_file
      local_wsdl = AVAILABLE_WSDLS.fetch(environment, AVAILABLE_WSDLS[:staging])
      Rails.root.join(local_wsdl)
    end

    def environment
      Rails.env
    end
  end

  Credentials = Struct.new(:account_id, :username, :password, :environment) do
    def self.fetch
      new(config.account_id,
          config.username,
          config.password,
          (Rails.env.production? ? :production : :staging)
      )
    end

    def self.config
      configatron.bergen
    end
  end
end
