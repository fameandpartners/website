module Spree
  module ApplicationHelper
    def method_missing(method, *args, &block)
      main_app.send(method, *args, &block)
    rescue NoMethodError
      super
    end

    def get_products_from_edit (edit, currency, user, count=9)
      searcher = Products::ProductsFilter.new(:edits => edit)
      searcher.current_user = user
      searcher.current_currency = currency
      return searcher.products.first(count)
    end
  end
end
