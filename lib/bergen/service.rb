# Note that this uses the Savon 1.2 API.

module Bergen
  class Service

    AVAILABLE_WSDLS = {
      production: 'lib/bergen/wsdl/production.publicapiws.asmx.xml',
      staging:    'lib/bergen/wsdl/staging.publicapiws.asmx.xml',
    }

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
end
