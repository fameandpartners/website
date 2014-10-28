module Feeds
  class Helpers
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::NumberHelper
    include ApplicationHelper
    include ProductsHelper

    def build_collection_product_path(collection_id, product_id, options = {})
      path_parts = ['collection', collection_id, product_id]
      path = "/" + path_parts.compact.join('/')
      path = "#{path}?#{options.to_param}" if options.present?

      url_without_double_slashes(path)
    end
  end
end