require_relative '../detectors/version_codes'

module Middleware
  module SiteVersion
    module Detectors
      class Path
        include VersionCodes

        VALID_PATHS   = [AU_CODE].join('|')
        SV_CODE_REGEX = /^\/(?<sv_code>#{VALID_PATHS})?.*$/

        def detect_site_version(rack_request)
          rack_request.path.match(SV_CODE_REGEX)[:sv_code] || default_code
        end

        private

        def default_code
          US_CODE
        end

      end
    end
  end
end
