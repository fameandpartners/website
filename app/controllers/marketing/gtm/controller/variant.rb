module Marketing
  module Gtm
    module Controller
      module Variant
        extend ActiveSupport::Concern

        private

        def append_gtm_variant(spree_variant:)
          variant_presenter = Marketing::Gtm::Presenter::Variant.new(spree_variant: spree_variant)
          @gtm_container.append(variant_presenter)
        end
      end
    end
  end
end
