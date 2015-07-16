module Feeds
  class Helpers
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::NumberHelper
    include PathBuildersHelper

    # PathBuildersHelper depends on AcionController::UrlFor#url_options
    def url_options
      {}
    end
  end
end
