require_relative './base'

module Middleware
  module SiteVersion
    module Detectors
      class Subdomain < Base
        def detect_site_version(rack_request)
          if rack_request.host.start_with?('au.')
            AU_CODE
          else
            default_code
          end
        end

        def default_url_options(site_version)
          { site_version: nil }
        end

        # TODO: Notice that this is only viable for dev/test env, since it hardcode the `lvh.me` domain
        def site_version_url(current_url, site_version)
          versioned_uri      = Addressable::URI.parse(current_url)
          versioned_uri.host = "#{site_version.permalink}.lvh.me"
          versioned_uri.to_s
        end
      end
    end
  end
end
