module WeddingAtelier
  class Customization
    include ActiveModel::Serialization
    include ActiveModel::SerializerSupport

    attr_accessor :silhouettes,
                  :fabrics,
                  :colours,
                  :lengths,
                  :sizes,
                  :assistants,
                  :heights

    def initialize(event)
      @silhouettes = Spree::Taxon.where(permalink: 'base-silhouette').first.products

      # TODO: colors should be captures from products
      @colours     = Spree::OptionType.color.option_values
      # TODO: Lengths, sizes and fabrics heights, should be captured from customization values of the base-sillhouete products
      @fabrics     = Spree::OptionType.fabric.option_values
      @lengths     = Spree::OptionType.length.option_values
      @sizes       = Spree::OptionType.size.option_values
      @heights     = WeddingAtelier::Height.definitions

      @assistants = event.assistants
    end
  end
end
