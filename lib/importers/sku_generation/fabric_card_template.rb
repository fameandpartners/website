require 'active_model'

module Importers
  module SkuGeneration
    class FabricCardTemplate
      include ActiveModel::Validations
      attr_accessor :name, :sku_component, :colours

      validates_presence_of :name, :sku_component

      def initialize(name, sku_component)
        @name = name
        @sku_component = sku_component
        @colours = []
      end
    end
  end
end
