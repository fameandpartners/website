module Repositories; end
class Repositories::ProductColor
  class << self
    # colors guarantee will be reloaded after restart... we can live with that
    def read_all
      @colors ||= Spree::Variant.color_option_type.try(:option_values) || []
    end
  end
end
