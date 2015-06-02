module Concerns
  module GlobalController
    extend ActiveSupport::Concern

    included do
      skip_before_filter :check_site_version
    end
  end
end

