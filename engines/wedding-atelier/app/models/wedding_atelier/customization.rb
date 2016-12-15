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
                  :heights,
                  :site_version

    def initialize(properties = {})
      @silhouettes = properties[:silhouettes]
      @fabrics = properties[:fabrics]
      @colours = properties[:colours]
      @lengths = properties[:lengths]
      @sizes = properties[:sizes]
      @assistants = properties[:assistants]
      @heights = properties[:heights]
      @site_version = properties[:site_version]
    end
  end
end
