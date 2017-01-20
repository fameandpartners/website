module WeddingAtelier
  class Sizing
    include ActiveModel::Serialization
    include ActiveModel::SerializerSupport

    attr_accessor :sizes,
                  :heights

    def initialize
      @sizes = Spree::OptionType.find_by_name('dress-size').option_values
      @heights = WeddingAtelier::Height.definitions
    end
  end
end
