module Products
  CollectionPresenter = Struct.new(
    :products,
    :total_products,
    :collection,
    :style,
    :styles,
    :event,
    :bodyshape,
    :color,
    :sale,
    :query_string,
    :order,
    :details,
    :site_version) do

    def self.from_hash(hash)
      instance = new
      hash.map { |k,v| instance[k] = v }
      instance
    end

    def use_auto_discount!(auto_discount)
      if auto_discount&.amount.to_i > 0
        self.products.each do |product|
          product.use_auto_discount!(auto_discount)
        end
      end
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

      result[:products] = self.products.map do |product|
        product.to_h.merge(
          collection_path: ApplicationController.helpers.collection_product_path(product),
          prices: product.prices
        )
      end
      result
    end
  end
end
