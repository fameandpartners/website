module Marketing
  module Gtm
    module Controller
      module Container
        DEFAULT_PAGE_TYPE = 'default'

        extend ActiveSupport::Concern
        include CommonHelper

        included do
          before_filter :include_gtm_container

          helper_method :append_gtm_page
        end

        private

        def gtm_page_type
          DEFAULT_PAGE_TYPE
        end

        def include_gtm_container
          user_presenter   = Presenter::User.new(spree_user: spree_current_user, request_ip: request.ip, session: session)
          device_presenter = Presenter::Device.new(user_agent: request.user_agent)
          site_presenter   = Presenter::Site.new(current_site_version: current_site_version)

          @gtm_container = Presenter::Container.new(presenters: [user_presenter, device_presenter, site_presenter])
        end

        def append_gtm_page
          page = Presenter::Page.new(type: gtm_page_type, meta_description: get_meta_description, title: get_title, url: request.url)
          @gtm_container.append(page)
        end
      end
    end
  end
end
