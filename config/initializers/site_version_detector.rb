module UrlHelpers
  module SiteVersion
    class Detector
      AVAILABLE_DETECTORS = {
          subdomain:        Middleware::SiteVersion::Detectors::Subdomain,
          top_level_domain: Middleware::SiteVersion::Detectors::Domain,
          path:             Middleware::SiteVersion::Detectors::Path
      }

      class << self
        def detector
          AVAILABLE_DETECTORS.fetch(configatron.site_version_detector_strategy, fallback).new
        end

        def fallback
          AVAILABLE_DETECTORS[:path]
        end
      end
    end
  end
end
