require_relative './base'

module Middleware
  module SiteVersion
    module Detectors
      class Domain < Base
        def detect_site_version(rack_request)
          if rack_request.host.end_with?('.com.au')
            AU_CODE
          else
            default_code
          end
        end
      end
    end
  end
end
