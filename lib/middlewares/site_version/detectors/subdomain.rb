require_relative './version_codes'

module Middleware
  module SiteVersion
    module Detectors
      class Subdomain
        include VersionCodes

        def detect_site_version(rack_request)
          if rack_request.host.start_with?('au.')
            AU_CODE
          else
            US_CODE
          end
        end
      end
    end
  end
end
