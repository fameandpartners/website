require_relative './detectors/path'
require_relative './detectors/domain'
require_relative './detectors/subdomain'

module Middleware
  module SiteVersion
    class Detector
      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)

        env['site_version_code'] = detector.detect_site_version(request)

        @app.call(env)
      rescue => exception
        render_exception(env, exception)
      end

      private

      def detector
        UrlHelpers::SiteVersion::Detector.detector
      end
    end
  end
end
