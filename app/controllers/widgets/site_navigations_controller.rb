module Widgets
  class SiteNavigationsController < ActionController::Base
    include Concerns::SiteVersion
    include Spree::Core::ControllerHelpers::Order
    include Spree::Core::ControllerHelpers::Auth

    # widget for main nav of the site
    # used in iframe
    def main_nav
      # default renderer
      render :main_nav, layout: false
    end

    def footer
      # NOOP
    end

    def default_url_options
      { host: 'www.fameandpartners.com' }
    end
  end
end
