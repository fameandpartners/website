module StaticsHelper

  def get_products_from_edit (edit, currency, user, count=9)
    searcher = Products::ProductsFilter.new(:edits => edit)
    searcher.current_user = user
    searcher.current_currency = currency
    return searcher.products.first(count)
  end

  def product_description(description)
    if description.present?
      strip_tags(description)
    end
  end

end  