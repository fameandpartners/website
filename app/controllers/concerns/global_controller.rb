module Concerns
  module GlobalController
    extend ActiveSupport::Concern

    included do
      skip_before_filter :enforce_param_site_version
    end
  end
end

