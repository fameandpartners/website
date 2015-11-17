module Middleware
  module SiteVersion
    module Detectors
      class Path
        VALID_PATHS = %w(au)

        def detect_site_version(rack_request)
          paths = VALID_PATHS.join('|')
          rack_request.path.match(/^\/(?<sv_code>#{paths})?.*$/) { |match| match[:sv_code] }
        end
      end
    end
  end
end
