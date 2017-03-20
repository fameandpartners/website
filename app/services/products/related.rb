module Products
  class Related
    extend Forwardable

    attr_reader :product, :site_version

    def_delegators :@product, :id, :name

    def initialize(product: nil, site_version: nil)
      @product      = product
      @site_version = site_version
    end

    def discount
      Repositories::Discount.get_product_discount(product.id)
    end

    def price
      product.site_price_for(site_version || SiteVersion.default)
    end

    def image
      Repositories::ProductImages.new(product: product).read(cropped: true)
    end

    def color
      Repositories::ProductColors.read(image.try(:color_id))
    end
  end
end
