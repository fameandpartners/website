module Concerns
  module GtmContainer
    extend ActiveSupport::Concern

    included do
      before_filter :include_gtm_container,
                    :append_user_presenter,
                    :append_device_presenter,
                    :append_site_presenter
    end

    def include_gtm_container
      @gtm_container = Marketing::Gtm::Container.new
    end

    def append_user_presenter
      user = Marketing::Gtm::UserPresenter.new(spree_user: spree_current_user, request_ip: request.ip)
      @gtm_container.append(user)
    end

    def append_device_presenter
      device = Marketing::Gtm::DevicePresenter.new(user_agent: request.user_agent)
      @gtm_container.append(device)
    end

    def append_site_presenter
      site = Marketing::Gtm::SitePresenter.new(current_site_version: current_site_version)
      @gtm_container.append(site)
    end
  end
end

