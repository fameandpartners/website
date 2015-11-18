module Middleware
  module SiteVersion
    module Detectors
      class Domain
        US_CODE = 'us'.freeze
        AU_CODE = 'au'.freeze

        def detect_site_version(rack_request)
          if rack_request.host.end_with?('.com.au')
            'au'
          else
            'us'
          end
        end
      end
    end
  end
end
