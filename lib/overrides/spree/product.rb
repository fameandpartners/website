module Overrides
  module Spree
    module Product
      extend ActiveSupport::Concern

      included do
        # include Elastic::Model

        has_one :style_profile,
                :class_name => '::ProductStyleProfile',
                :foreign_key => :product_id

        before_create do
          build_style_profile
        end
      end
    end
  end
end

Spree::Product.send(:include, Overrides::Spree::Product)
