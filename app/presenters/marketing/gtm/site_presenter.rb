module Marketing
  module Gtm
    class SitePresenter
      attr_reader :current_site_version

      def initialize(current_site_version: SiteVersion.default)
        @current_site_version = current_site_version
      end

      def code
        current_site_version.code
      end

      def key
        'site'.freeze
      end

      def body
        {
            version: code
        }
      end
    end
  end
end
