require 'active_model'

module Importers
  module SkuGeneration
    class FabricCardColourTemplate
      include ActiveModel::Validations

      attr_accessor :number, :name
      validates_presence_of :number, :name
      validates_numericality_of :number

      def initialize(number, name)
        @number = number
        @name = name
      end

      def sku_component
        # sprintf("%03d", number)
        return "---" unless valid?
        sprintf("%03d", number)
      end

      def to_s
        "<#{self.class.name} @number=#{@number}, @name=#{@name}#{ ', invalid' unless valid?}>"
      end
    end
  end
end
