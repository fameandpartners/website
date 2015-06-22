require 'active_model'

module Importers
  module SkuGeneration
    class FabricColourTemplate
      include ActiveModel::Validations
      attr_accessor :name, :presentation

      validates_presence_of :name

      def initialize(name, presentation = nil)
        @name = name
        @presentation = presentation.presence || name
      end
    end
  end
end
