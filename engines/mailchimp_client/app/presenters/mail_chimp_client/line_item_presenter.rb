module MailChimpClient
  class LineItemPresenter

    attr_accessor :line_item, :api

    def initialize(line_item)
      self.line_item = line_item
      self.api = MailChimpClient::API.new
    end

    def read
      product = line_item.variant.product
      api.add_product(product) unless api.product_exists?(product)

      sku = CustomItemSku.new(line_item).call
      api.add_variant(product, sku) unless api.variant_exists?(product, sku)

      {
        id:                 line_item.id.to_s,
        product_id:         line_item.variant.product.sku,
        product_variant_id: CustomItemSku.new(line_item).call,
        quantity:           1,
        price:              line_item.price
      }
    end
  end
end
