module Products
  CollectionPresenter = Struct.new(
    :products,
    :total_products,
    :collection,
    :style,
    :event,
    :bodyshape,
    :color,
    :sale,
    :query_string,
    :order,
    :details) do

    def self.from_hash(hash)
      instance = new
      hash.map { |k,v| instance[k] = v }
      instance
    end

    def to_h
      members.each_with_object({}) do |m, h|
        h[m] = self[m]
      end
    end

    def any?
      !none?
    end

    def none?
      total_products.to_i == 0
    end

    def serialize
      result = self.to_h
      result[:details] = self.details.to_h
      result[:details][:banner] = self.details.banner.to_h

      result[:products] = self.products.map do |product|
        sale_price = product.price.apply(product.discount)
        product.to_h.merge(
          collection_path: ApplicationController.helpers.collection_product_path(product),
          price: product.price.display_price.to_s,
          sale_price: sale_price.present? ? sale_price.display_price.to_s : nil
        )
      end
      result
    end
  end
end
