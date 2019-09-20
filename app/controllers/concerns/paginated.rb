module Concerns
  module Paginated
    extend ActiveSupport::Concern

    included do
      helper_method :per_page, :page
    end

    def page
      params.fetch(:page) { 1 }
    end

    def per_page
      params.fetch(:per_page) { default_per_page }
    end

    def default_per_page
      20
    end
  end
end
