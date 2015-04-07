class Products::CollectionPresenter < FastOpenStruct

  def any?
    !none?
  end

  def none?
    total_products.to_i == 0
  end

  def serialize
    result = self.marshal_dump.clone
    result[:details]  = self.details.marshal_dump
    result[:details][:banner] = self.details.banner.marshal_dump

    result[:products] = self.products.map do |product|
      sale_price = product.price.apply(product.discount)
      product.marshal_dump.merge(
        collection_path: ApplicationController.helpers.collection_product_path(product),
        price: product.price.display_price.to_s,
        sale_price: sale_price.present? ? sale_price.display_price.to_s : nil
      )
    end
    result
  end
end
