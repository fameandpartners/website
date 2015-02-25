class Products::CollectionPresenter < OpenStruct
  def serialize
    result = self.marshal_dump.clone
    result[:details]  = self.details.marshal_dump
    result[:products] = self.products.map do |product| 
      product.marshal_dump.merge(
        collection_path: ApplicationController.helpers.collection_product_path(product)
      )
    end
    result
  end
end

