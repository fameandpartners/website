module Middleware
  module SiteVersion
    module Detectors
      class Subdomain
        US_CODE = 'us'.freeze
        AU_CODE = 'au'.freeze

        def detect_site_version(rack_request)
          if rack_request.host.start_with?('au.')
            'au'
          else
            'us'
          end
        end
      end
    end
  end
end
