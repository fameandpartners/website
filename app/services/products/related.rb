module Products
  class Related
    attr_reader :product, :site_version, :presenter

    delegate :id, :name, to: :product
    delegate :prices, to: :presenter

    def initialize(product: nil, site_version: nil)
      @product      = product
      @price        = product.site_price_for(site_version || SiteVersion.default)
      @presenter    = Products::Presenter.new(product: @product, price: @price)
      @site_version = site_version
    end

    def discount
      product.discount
    end

    def price
      presenter.price_amount
    end

    def image
      Repositories::ProductImages.new(product: product).read(cropped: true)
    end

    def color
      Repositories::ProductColors.read(image.try(:color_id))
    end
  end
end
