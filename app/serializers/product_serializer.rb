class ProductSerializer < ActiveModel::Serializer
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include Spree::ProductsHelper

  attributes :name, :image, :description

  def image
    image = object.images.first
    image.present? ? image.attachment(:small) : '/assets/noimage/product.png'
  end

  def description
    object.description || object.property('short_description')
  end
end
