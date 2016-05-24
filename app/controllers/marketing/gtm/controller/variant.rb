module Marketing
  module Gtm
    module Controller
      module Variant
        extend ActiveSupport::Concern

        private

        def gtm_page_type
          'product'
        end

        def append_gtm_variant(variant:, color:, size:)
          product_presenter = variant.product.presenter_as_details_resource(current_site_version)
          product_presenter.sku = VariantSku.sku_from_variant(variant, size, color)
          gtm_product = Marketing::Gtm::Presenter::Product.new(product_presenter: product_presenter)
          @gtm_container.append(gtm_product)
        end
      end
    end
  end
end
