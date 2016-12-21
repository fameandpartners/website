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
      @silhouettes = Spree::Taxon.find_by_permalink('base-silhouette').products
      @fabrics = Spree::OptionType.find_by_name('wedding-atelier-fabrics').option_values
      @colours = Spree::OptionType.find_by_name('wedding-atelier-colors').option_values
      @lengths = Spree::OptionType.find_by_name('wedding-atelier-lengths').option_values
      @sizes = Spree::OptionType.find_by_name('dress-size').option_values
      @assistants = event.assistants
      @heights = [
          "5'19 / 177cm ",
          "5'19 / 180cm ",
          "5'19 / 190cm ",
          "5'19 / 200cm "
      ]
    end
  end
end
