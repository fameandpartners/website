module MailChimp
  class LineItemPresenter

    attr_accessor :line_item, :api

    def initialize(line_item)
      self.line_item = line_item
      self.api = MailChimpClient::API.new
    end

    def to_h
      product = line_item.variant.product
      product_present = Product::Create.(product)

      sku = CustomItemSku.new(line_item).call
      variant_present = Variant::Create.(product, sku)

      raise 'Error creating product with variant' unless product_present && variant_present

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
