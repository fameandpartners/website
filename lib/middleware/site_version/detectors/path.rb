require_relative './base'

# TODO: After .com.au migration, this detector will be obsolete!
module Middleware
  module SiteVersion
    module Detectors
      class Path < Base
        VALID_PATHS   = Regexp.union(AU_CODE)
        SV_CODE_REGEX = /^\/(?<sv_code>#{VALID_PATHS})?.*$/

        def detect_site_version(rack_request)
          rack_request.path.match(SV_CODE_REGEX)[:sv_code] || default_code
        end

        def default_url_options(site_version)
          if site_version.default?
            { site_version: nil }
          else
            { site_version: site_version.code }
          end
        end
      end
    end
  end
end
