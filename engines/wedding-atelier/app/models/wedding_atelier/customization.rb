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
      @fabrics = Spree::OptionType.fabric.option_values
      @colours = Spree::OptionType.color.option_values
      @lengths = Spree::OptionType.length.option_values
      @sizes = Spree::OptionType.size.option_values
      @assistants = event.assistants
      @heights = WeddingAtelier::Height.definitions
    end
  end
end
