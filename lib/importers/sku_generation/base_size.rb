require 'active_model'

module Importers
  module SkuGeneration
    class BaseSize
      include ActiveModel::Validations
      attr_accessor :size

      DEFAULT_SIZES = [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]

      def self.size_set
        DEFAULT_SIZES.collect {|size| new(size) }
      end

      validates_presence_of :size
      validates_inclusion_of :size, in: DEFAULT_SIZES

      def initialize(size)
        @size = size
      end

      def sku_component
        sprintf("%02dAU", size)
      end
    end
  end
end
