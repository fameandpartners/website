class ProductSerializer < ActiveModel::Serializer
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include Spree::ProductsHelper

  attributes :name,
             :image,
             :description,
             :short_description,
             :delivery_time

  def image
    image = object.images.first
    image.present? ? image.attachment(:small) : '/assets/noimage/product.png'
  end

  def description
    object.description || object.property('short_description')
  end

  def short_description
    if object.description.present?
      truncate(strip_tags(object.description.gsub('&nbsp;', ' ')), :length => 100)
    else
      t(:product_has_no_description)
    end
  end

  def delivery_time
    object.delivery_time_as_string(:long)
  end
end
