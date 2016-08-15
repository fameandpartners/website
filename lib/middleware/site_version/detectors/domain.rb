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

        def default_url_options(site_version)
          { site_version: nil }
        end

        def site_version_url(current_url, site_version)
          versioned_uri      = Addressable::URI.parse(current_url)
          versioned_uri.host = site_version.domain
          versioned_uri.to_s
        end
      end
    end
  end
end
