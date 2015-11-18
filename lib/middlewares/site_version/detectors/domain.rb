require_relative './version_codes'

module Middleware
  module SiteVersion
    module Detectors
      class Domain
        include VersionCodes

        def detect_site_version(rack_request)
          if rack_request.host.end_with?('.com.au')
            AU_CODE
          else
            US_CODE
          end
        end
      end
    end
  end
end
