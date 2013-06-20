module Overrides
  module Spree
    module Product
      extend ActiveSupport::Concern

      included do
        has_one :style_profile, :class_name => '::ProductStyleProfile'
      end
    end
  end
end

Spree::Product.send(:include, Overrides::Spree::Product)
