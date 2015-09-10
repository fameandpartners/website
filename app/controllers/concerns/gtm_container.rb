module Concerns
  module GtmContainer
    extend ActiveSupport::Concern

    included do
      before_filter :include_gtm_container
    end

    private

    def include_gtm_container
      user_presenter   = Marketing::Gtm::UserPresenter.new(spree_user: spree_current_user, request_ip: request.ip)
      device_presenter = Marketing::Gtm::DevicePresenter.new(user_agent: request.user_agent)
      site_presenter   = Marketing::Gtm::SitePresenter.new(current_site_version: current_site_version)

      @gtm_container = Marketing::Gtm::Container.new(presenters: [user_presenter, device_presenter, site_presenter])
    end
  end
end

