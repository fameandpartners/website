module Widgets
  class SiteNavigationsController < ActionController::Base
    include Concerns::SiteVersion

    layout false

    def main_nav
      # NOOP
    end

    def footer
      # NOOP
    end

    def default_url_options
      { host: 'www.fameandpartners.com' }
    end
  end
end
