module Feeds
  class Helpers
    include ActionView::Helpers::SanitizeHelper
    include ApplicationHelper
    include ProductsHelper

    def initialize(version)
      @current_site_version = version
    end

    def url_options
      @url_options ||= HashWithIndifferentAccess.new(site_version: @current_site_version.permalink)
    end
  end
end