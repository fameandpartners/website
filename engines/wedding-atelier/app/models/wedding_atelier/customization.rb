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
      available_colors = WeddingAtelier::Defaults.available_colors.map{ |c| c[:name] }
      @silhouettes = Spree::Taxon.find_by_permalink('base-silhouette').products
      # TODO: colors should be captures from products
      @colours = Spree::OptionValue.where(name: available_colors)
      @sizes = Spree::OptionType.size.option_values
      @assistants = event.assistants
      @heights = WeddingAtelier::Height.definitions
    end
  end
end
