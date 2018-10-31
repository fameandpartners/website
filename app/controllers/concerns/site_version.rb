module Concerns
  module SiteVersion
    extend ActiveSupport::Concern

    included do
      attr_writer :current_site_version

      append_before_filter :add_site_version_to_mailer

      helper_method :current_site_version
    end

    def current_site_version
      @current_site_version ||= ::SiteVersion.by_permalink_or_default(site_version_param)
    end

    def site_version_param
      request.env['site_version_code'] || ::SiteVersion.default.code
    end

    def current_currency
      current_site_version.try(:currency) || ::Spree::Config[:currency]
    end

    def add_site_version_to_mailer
      ActionMailer::Base.default_url_options.merge!(default_url_options)
    end

    def default_url_options
      UrlHelpers::SiteVersion::Detector.detector.default_url_options(current_site_version)
    end
  end
end
