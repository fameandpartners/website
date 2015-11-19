module Middleware
  module SiteVersion
    module Detectors
      class Base
        US_CODE = 'us'.freeze
        AU_CODE = 'au'.freeze

        def default_code
          US_CODE
        end
      end
    end
  end
end
