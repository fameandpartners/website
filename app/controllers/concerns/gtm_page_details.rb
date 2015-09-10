module Concerns
  module GtmPageDetails
    DEFAULT_PAGE_TYPE = 'default'

    extend ActiveSupport::Concern
    include CommonHelper

    included do
      helper_method :append_gtm_page
    end

    private

    def append_gtm_page
      page_type = @gtm_page_type || DEFAULT_PAGE_TYPE
      page      = Marketing::Gtm::PagePresenter.new(type: page_type, meta_description: get_meta_description, title: get_title, url: request.url)
      @gtm_container.append(page)
    end
  end
end

