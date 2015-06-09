module StaticsHelper
  def product_description(description)
    if description.present?
      strip_tags(description)
    end
  end
end
